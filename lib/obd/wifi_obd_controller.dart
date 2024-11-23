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
	Timer? periodicTimer;
	final rawDataController = StreamController<String>.broadcast();
	Vehicle? selectedVehicle;

	void setVehicle(Vehicle vehicle) {
		selectedVehicle = vehicle;
	}

	Stream<Map<String, dynamic>> get dataStream => streamController.stream;
	Stream<String> get rawDataStream => rawDataController.stream;

	Future<void> connect() async {
		try {
			socket = await Socket.connect('192.168.0.10', 35000,
					timeout: const Duration(seconds: 30));
			isConnected = true;

			await initializeObd();
			startPeriodicUpdates();

			// Подключаемся к сокету
			socket!.listen(
				onData,
				onError: onError,
				onDone: onDone,
			);
		} catch (e) {
			print('Ошибка подключения: $e');
			rethrow;
		}
	}

	Future<void> initializeObd() async {
		await sendCommand('ATZ'); // Сброс
		await Future.delayed(const Duration(milliseconds: 1000));
		await sendCommand('ATE0'); // Выключаем эхо
		await sendCommand('ATM0'); // Выключаем мониторинг
		await sendCommand('ATL0'); // Выключаем линейные разрывы
		await sendCommand('ATST62'); // Выключаем проверку скорости
		await sendCommand('ATS0'); // Выключаем пробелы
		await sendCommand('AT@1'); // Выбираем протокол OBDII
		await sendCommand('ATI'); // Запрашиваем информацию об устройстве
		await sendCommand('ATH0'); // Выключаем заголовки
		await sendCommand('ATAT1'); // Включаем автоответ
		await sendCommand('ATDPN'); // Запрашиваем количество параметров
		await sendCommand('ATSP0'); // Автоматический выбор протокола
	}

	void startPeriodicUpdates() {
		periodicTimer?.cancel();
		periodicTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
			if (isConnected && selectedVehicle != null) {
				// Создаем копию списка параметров, чтобы избежать проблем с асинхронностью
				final parameters = List<String>.from(selectedVehicle!.supportedParameterKeys);
				
				for (var paramKey in parameters) {
					final param = ObdParameters.parameters[paramKey];
					if (param != null) {
						await sendCommand(param.pid);
						await Future.delayed(const Duration(milliseconds: 5));
					}
				}
			}
		});
	}

	void disconnect() {
		periodicTimer?.cancel();
		socket?.destroy();
		socket = null;
		isConnected = false;
	}

	void dispose() {
		disconnect();
		streamController.close();
		rawDataController.close();
	}

	void onError(Object error) {
		print('Ошибка соединения: $error');
		disconnect();
	}

	void onDone() {
		print('Соединение закрыто');
		disconnect();
	}

	void onData(Uint8List data) {
		try {
			String response = String.fromCharCodes(data);
			print('Сырой ответ OBD: $response');
			
			rawDataController.add(response);
			Map<String, dynamic> parsedData = {};

			for (var param in ObdParameters.parameters.values) {
				try {
					final value = param.parser(response);
					if (value != null) {
						parsedData[param.key] = value;
						print('Разобрано ${param.key}: $value');
					}
				} catch (e) {
					print('Ошибка парсинга ${param.key}: $e');
				}
			}

			if (parsedData.isNotEmpty) {
				streamController.add(parsedData);
			}
		} catch (e) {
			print('Общая ошибка обработки данных: $e');
		}
	}

	Future<void> sendCommand(String command) async {
		if (socket != null && isConnected) {
			socket!.write('$command\r');
			await socket!.flush();
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
}
