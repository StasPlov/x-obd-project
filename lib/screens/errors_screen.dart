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
			final errors = (await widget.obdController.parseDtcResponse(response));
			return errors;
		} catch (e) {
			print('Ошибка чтения DTC: $e');
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
			),
		);
	}

	Future<void> _scanForErrors() async {
		setState(() => isScanning = true);
		try {
			final activeErrors = await _readDtcErrors(false);
			final pendingErrors = await _readDtcErrors(true);
			setState(() => errors = [...activeErrors, ...pendingErrors]);
		} finally {
			setState(() => isScanning = false);
		}
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
			body: RefreshIndicator(
				onRefresh: _scanForErrors,
				child: CustomScrollView(
					slivers: [
						SliverToBoxAdapter(
							child: Padding(
								padding: const EdgeInsets.all(16),
								child: Column(
									children: [
										_buildErrorsSummaryCard(),
										const SizedBox(height: 16),
										if (errors.isNotEmpty) ...[
											_buildErrorsList('Активные ошибки', 
												errors.where((e) => !e.isPending).toList()),
											const SizedBox(height: 16),
											_buildErrorsList('Отложенные ошибки', 
												errors.where((e) => e.isPending).toList()),
										],
										if (!isScanning && errors.isEmpty)
											const Center(
												child: Text('Нажмите кнопку для сканирования ошибок'),
											),
									],
								),
							),
						),
					],
				),
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

	Widget _buildErrorsList(String title, List<DtcError> errors) {
		// Группируем ошибки по системам
		final groupedErrors = groupBy(errors, (DtcError e) => e.system);
		
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Text(
					title,
					style: const TextStyle(
						fontSize: 18,
						fontWeight: FontWeight.bold,
					),
				),
				const SizedBox(height: 16),
				...groupedErrors.entries.map((entry) => _buildSystemGroup(entry.key, entry.value)),
			],
		);
	}

	Widget _buildSystemGroup(String system, List<DtcError> errors) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Padding(
					padding: const EdgeInsets.symmetric(vertical: 8),
					child: Text(
						system,
						style: const TextStyle(
							fontSize: 16,
							fontWeight: FontWeight.w500,
						),
					),
				),
				...errors.map((error) => _buildErrorItem(error)),
			],
		);
	}

	Widget _buildErrorItem(DtcError error) {
		return Container(
			margin: const EdgeInsets.only(bottom: 12),
			decoration: BoxDecoration(
				color: Theme.of(context).colorScheme.surfaceContainerHighest,
				borderRadius: BorderRadius.circular(16),
			),
			child: ListTile(
				contentPadding: const EdgeInsets.all(16),
				title: Row(
					children: [
						Text(
							error.code,
							style: const TextStyle(
								fontWeight: FontWeight.bold,
								fontSize: 16,
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
				subtitle: Padding(
					padding: const EdgeInsets.only(top: 8),
					child: Text(error.description),
				),
				trailing: const Icon(Icons.chevron_right),
				onTap: () {
					// TODO: Показать детали ошибки
				},
			),
		);
	}

	Widget _buildErrorsSummaryCard() {
		return Container(
			padding: const EdgeInsets.all(20),
			decoration: BoxDecoration(
				gradient: LinearGradient(
					colors: [
						Theme.of(context).colorScheme.errorContainer,
						Theme.of(context).colorScheme.error.withOpacity(0.7),
					],
					begin: Alignment.topLeft,
					end: Alignment.bottomRight,
				),
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
									const Text(
										'2 ошибки',
										style: TextStyle(
											fontSize: 32,
											fontWeight: FontWeight.bold,
											color: Colors.white,
										),
									),
									Text(
										'Требуется внимание',
										style: TextStyle(
											fontSize: 14,
											color: Colors.white.withOpacity(0.8),
										),
									),
								],
							),
							const Icon(
								Icons.warning_amber_rounded,
								size: 48,
								color: Colors.white,
							),
						],
					),
				],
			),
		);
	}
} 