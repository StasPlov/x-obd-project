import 'package:wifi_scan/wifi_scan.dart';
import 'dart:async';
import 'dart:io';

class NetworkScanner {
	static Future<List<WiFiAccessPoint>> findObdDevices() async {
		List<WiFiAccessPoint> obdDevices = [];
		
		try {
			// Проверяем разрешения
			final can = await WiFiScan.instance.canStartScan();
			if (can != CanStartScan.yes) {
				throw Exception('Нет разрешения на сканирование WiFi');
			}
			
			// Начинаем сканирование
			final result = await WiFiScan.instance.startScan();
			if (!result) {
				throw Exception('Не удалось начать сканирование');
			}
			
			// Получаем результаты
			final results = await WiFiScan.instance.getScannedResults();
			
			// Фильтруем только OBD устройства
			obdDevices = results.where((ap) {
				final name = ap.ssid.toUpperCase();
				return name.contains('OBD') || 
					   name.contains('ELM') || 
					   name.contains('WIFI') ||
					   name.contains('OBDII');
			}).toList();
			
		} catch (e) {
			print('Ошибка сканирования: $e');
			rethrow;
		}
		
		return obdDevices;
	}
	
	static Future<bool> checkDeviceConnection(String ssid) async {
		try {
			// Пробуем подключиться к устройству по стандартному порту OBD
			final socket = await Socket.connect(
				'192.168.0.10', // Стандартный IP для многих OBD адаптеров
				35000,
				timeout: const Duration(seconds: 2),
			);
			
			socket.write('ATZ\r\n'); // Отправляем тестовую команду
			await socket.close();
			return true;
		} catch (e) {
			print('Ошибка проверки устройства $ssid: $e');
			return false;
		}
	}
} 