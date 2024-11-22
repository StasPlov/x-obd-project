import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:x_obd_project/models/vehicle.dart';
import 'package:x_obd_project/data/obd_parameters.dart';
import 'package:x_obd_project/models/dtc_error.dart';
import 'package:x_obd_project/data/dtc_codes.dart';

class WifiObdController {
  Socket? socket;
  bool isConnected = false;
  final streamController = StreamController<Map<String, dynamic>>.broadcast();
  Timer? _periodicTimer;
  final rawDataController = StreamController<String>.broadcast();
  Vehicle? selectedVehicle;

  void setVehicle(Vehicle vehicle) {
    selectedVehicle = vehicle;
  }

  Stream<Map<String, dynamic>> get dataStream => streamController.stream;
  Stream<String> get rawDataStream => rawDataController.stream;

  Future<void> connect() async {
    try {
      socket = await Socket.connect('192.168.0.10', 35000);
      isConnected = true;
      await _initializeObd();
      _startPeriodicUpdates();

      socket!.listen(
        _processResponse,
        onError: (error) {
          print('Ошибка соединения: $error');
          disconnect();
        },
        onDone: () {
          print('Соединение закрыто');
          disconnect();
        },
      );
    } catch (e) {
      print('Ошибка подключения: $e');
      rethrow;
    }
  }

  Future<void> _initializeObd() async {
    await sendCommand('ATZ'); // Сброс
    await Future.delayed(const Duration(milliseconds: 1000));
    await sendCommand('ATE0'); // Выключаем эхо
    await sendCommand('ATL0'); // Выключаем линейные разрывы
    await sendCommand('ATH0'); // Выключаем заголовки
    await sendCommand('ATS0'); // Выключаем пробелы
    await sendCommand('ATSP0'); // Автоматический выбор протокола
  }

  void _startPeriodicUpdates() {
    _periodicTimer?.cancel();
    _periodicTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if (isConnected && selectedVehicle != null) {
        for (var paramKey in selectedVehicle!.supportedParameterKeys) {
          final param = ObdParameters.parameters[paramKey];
          if (param != null) {
            await sendCommand(param.pid);
          }
        }
      }
    });
  }

  Future<void> sendCommand(String command) async {
    if (socket != null && isConnected) {
      socket!.write('$command\r');
      await socket!.flush();
    }
  }

  void _processResponse(Uint8List data) {
    String response = String.fromCharCodes(data).trim();
    rawDataController.add(response);

    Map<String, dynamic> parsedData = {};

    for (var param in ObdParameters.parameters.values) {
      final value = param.parser(response);
      if (value != null) {
        parsedData[param.key] = value;
      }
    }

    if (parsedData.isNotEmpty) {
      streamController.add(parsedData);
    }
  }

  Future<List<DtcError>> parseDtcResponse(String response) async {
    List<DtcError> errors = [];

    if (response.isEmpty || response == 'NO DATA' || response == 'ERROR') {
      return errors;
    }

    // Удаляем пробелы и разбиваем на пары символов
    final cleanResponse = response.replaceAll(' ', '');
    final pairs = RegExp(r'.{4}')
        .allMatches(cleanResponse)
        .map((m) => m.group(0)!)
        .toList();

    for (var code in pairs) {
      if (code == '0000') continue; // Пропускаем пустые коды

      final firstChar = code[0];
      final system = DtcCodes.systems[firstChar]?.name ?? 'Неизвестная система';
      final fullCode = '$firstChar${code.substring(1)}';

      errors.add(DtcError(
        code: fullCode,
        description: DtcCodes.getDescription(fullCode),
        severity: DtcCodes.getSeverity(fullCode),
        system: system,
        isPending: false, // Для отложенных ошибок установите true
      ));
    }

    return errors;
  }

  void disconnect() {
    _periodicTimer?.cancel();
    socket?.destroy();
    socket = null;
    isConnected = false;
  }

  void dispose() {
    disconnect();
    streamController.close();
    rawDataController.close();
  }
}
