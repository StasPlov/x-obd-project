import 'package:flutter/material.dart';
import 'package:x_obd_project/models/dtc_error.dart';
import 'package:x_obd_project/obd/obd_commands.dart';
import 'package:x_obd_project/obd/wifi_obd_controller.dart';
import 'package:collection/collection.dart';
import 'dart:async';

class ErrorsScreen extends StatefulWidget {
  final WifiObdController obdController;

  const ErrorsScreen({
    super.key, 
    required this.obdController,
  });

  @override
  State<ErrorsScreen> createState() => _ErrorsScreenState();
}

class _ErrorsScreenState extends State<ErrorsScreen> {
  bool isScanning = false;
  List<DtcError> errors = [];
  late Completer<String> _responseCompleter = Completer<String>();
  late StreamSubscription _responseSubscription;

  @override
  void initState() {
    super.initState();
    _responseSubscription = widget.obdController.rawDataStream.listen((response) {
      if (!_responseCompleter.isCompleted) {
        _responseCompleter.complete(response);
      }
    });
  }

  @override
  void dispose() {
    _responseSubscription.cancel();
    super.dispose();
  }

  Future<String> _sendCommandAndWaitResponse(String command) async {
    final completer = Completer<String>();
    _responseCompleter = completer;
    
    await widget.obdController.sendCommand(command);
    return completer.future.timeout(
      const Duration(seconds: 3),
      onTimeout: () => throw TimeoutException('Нет ответа от устройства'),
    );
  }

  Future<List<DtcError>> _readDtcErrors(bool pending) async {
    try {
      final command = pending ? ObdCommands.readPendingDtc : ObdCommands.readDtc;
      final response = await _sendCommandAndWaitResponse(command);
      final errors = await widget.obdController.parseDtcResponse(response);
      
      return errors.map((e) => DtcError(
        code: e.code,
        description: e.description,
        severity: e.severity,
        system: e.system,
        isPending: pending,
      )).toList();
    } catch (e) {
      _showSnackBar('Ошибка чтения DTC: $e', Colors.red);
      return [];
    }
  }

  Future<void> _clearErrors() async {
    try {
      await _sendCommandAndWaitResponse(ObdCommands.clearDtc);
      setState(() {
        errors.clear();
      });
      _showSnackBar('Ошибки успешно сброшены', Colors.green);
    } catch (e) {
      _showSnackBar('Ошибка при сбросе: $e', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _scanForErrors() async {
    setState(() => isScanning = true);
    try {
      final activeErrors = await _readDtcErrors(false);
      final pendingErrors = await _readDtcErrors(true);
      
      if (mounted) {
        setState(() => errors = [...activeErrors, ...pendingErrors]);
      }
      
      if (errors.isEmpty) {
        _showSnackBar(
          'Диагностика завершена: ошибок не обнаружено', 
          Colors.green
        );
      }
    } catch (e) {
      _showSnackBar('Ошибка сканирования: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() => isScanning = false);
      }
    }
  }

  void _showErrorDetails(DtcError error) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Код ошибки: ${error.code}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Система: ${error.system}'),
            const SizedBox(height: 8),
            Text('Серьезность: ${error.severity}'),
            const SizedBox(height: 8),
            Text('Статус: ${error.isPending ? "Отложенная" : "Активная"}'),
            const SizedBox(height: 16),
            const Text(
              'Описание:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(error.description),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Закрыть'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ошибки'),
        actions: [
          if (errors.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearErrors,
              tooltip: 'Сбросить ошибки',
            ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (errors.isEmpty && !isScanning)
                    Column(
                      children: [
                        const Icon(
                          Icons.search,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Нажмите кнопку "Сканировать",\nчтобы проверить наличие ошибок',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    _buildErrorsSummary(),
                    const SizedBox(height: 24),
                    _buildErrorsList(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isScanning ? null : _scanForErrors,
        icon: isScanning 
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : const Icon(Icons.search),
        label: Text(isScanning ? 'Сканирование...' : 'Сканировать'),
      ),
    );
  }

  Widget _buildErrorsSummary() {
    final activeErrors = errors.where((e) => !e.isPending).length;
    final pendingErrors = errors.where((e) => e.isPending).length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${activeErrors + pendingErrors} ошибок',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  Text(
                    '$activeErrors активных, $pendingErrors отложенных',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onErrorContainer.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.warning_amber_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorsList() {
    if (errors.isEmpty) return const SizedBox.shrink();
    
    final groupedErrors = groupBy(errors, (DtcError e) => e.system);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedErrors.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                entry.key,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ...entry.value.map((error) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Row(
                  children: [
                    Text(
                      error.code,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: error.severity == 'Критическая'
                            ? Colors.red.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        error.severity,
                        style: TextStyle(
                          fontSize: 12,
                          color: error.severity == 'Критическая'
                              ? Colors.red
                              : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(error.description),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showErrorDetails(error),
              ),
            )),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }
} 