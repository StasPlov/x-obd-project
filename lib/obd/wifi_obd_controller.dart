import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:x_obd_project/models/vehicle.dart';
import 'obd_data_parser.dart';

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

	// Получаем стрим с данными
	Stream<Map<String, dynamic>> get dataStream => streamController.stream;
	Stream<String> get rawDataStream => rawDataController.stream;

	Future<void> connect() async {
		try {
			// Подключаемся к OBD адаптеру (предполагаем, что WiFi соединение уже установлено)
			socket = await Socket.connect('192.168.0.10', 35000);
			isConnected = true;

			// Инициализация OBD
			await _initializeObd();
			
			// Начинаем периодический опрос данных
			_startPeriodicUpdates();

			// Слушаем ответы от устройства
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
		// Инициализация OBD адаптера
		await sendCommand('ATZ');     // Сброс
		await Future.delayed(const Duration(milliseconds: 1000));
		await sendCommand('ATE0');    // Выключаем эхо
		await sendCommand('ATL0');    // Выключаем линейные разрывы
		await sendCommand('ATH0');    // Выключаем заголовки
		await sendCommand('ATS0');    // Выключаем пробелы
		await sendCommand('ATSP0');   // Автоматический выбор протокола
	}

	void _startPeriodicUpdates() {
		_periodicTimer?.cancel();
		_periodicTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
			if (isConnected && selectedVehicle != null) {
				for (var pid in selectedVehicle!.supportedPids.values) {
					await sendCommand(pid);
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
		
		// Отправляем сырые данные в стрим
		rawDataController.add(response);
		
		Map<String, dynamic> parsedData = {};

		if (response.startsWith('41')) {
			if (response.startsWith('41 0C')) {
				parsedData['rpm'] = ObdDataParser.parseRPM(response);
			} else if (response.startsWith('41 0D')) {
				parsedData['speed'] = ObdDataParser.parseSpeed(response);
			} else if (response.startsWith('41 11')) {
				parsedData['throttle'] = ObdDataParser.parseThrottle(response);
			} else if (response.startsWith('41 05')) {
				parsedData['temp'] = ObdDataParser.parseTemp(response);
			} else if (response.startsWith('41 04')) {
				parsedData['engineLoad'] = ObdDataParser.parseEngineLoad(response);
			} else if (response.startsWith('41 2F')) {
				parsedData['fuelLevel'] = ObdDataParser.parseFuelLevel(response);
			}
		} else if (response.startsWith('ATRV')) {
			parsedData['voltage'] = ObdDataParser.parseVoltage(response);
		}

		if (parsedData.isNotEmpty) {
			streamController.add(parsedData);
		}
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
