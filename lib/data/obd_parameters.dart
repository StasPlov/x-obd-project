import '../models/obd_parameter.dart';

class ObdParameters {
	static const String categoryEngine = 'engine';
	static const String categoryMovement = 'movement';
	static const String categoryFuel = 'fuel';
	static const String categoryElectrical = 'electrical';
	static const String categoryTransmission = 'transmission';
	static const String categoryExhaust = 'exhaust';

	static final Map<String, ObdParameter> parameters = {
		'rpm': ObdParameter(
			key: 'rpm',
			pid: '010C',
			name: 'Обороты двигателя',
			unit: 'об/мин',
			category: categoryEngine,
			parser: (String response) {
				if (response.startsWith('41 0C')) {
					var bytes = response.substring(6).trim().split(' ');
					if (bytes.length >= 2) {
						int a = int.parse(bytes[0], radix: 16);
						int b = int.parse(bytes[1], radix: 16);
						return ((a * 256) + b) ~/ 4;
					}
				}
				return null;
			},
		),

		'engineLoad': ObdParameter(
			key: 'engineLoad',
			pid: '0104',
			name: 'Нагрузка двигателя',
			unit: '%',
			category: categoryEngine,
			parser: (String response) {
				if (response.startsWith('41 04')) {
					var byte = response.substring(6).trim();
					return (int.parse(byte, radix: 16) * 100) / 255;
				}
				return null;
			},
		),

		'coolantTemp': ObdParameter(
			key: 'coolantTemp',
			pid: '0105',
			name: 'Температура ОЖ',
			unit: '°C',
			category: categoryEngine,
			parser: (String response) {
				if (response.startsWith('41 05')) {
					var byte = response.substring(6).trim();
					return int.parse(byte, radix: 16) - 40;
				}
				return null;
			},
		),

		'timing': ObdParameter(
			key: 'timing',
			pid: '010E',
			name: 'Угол опережения',
			unit: '°',
			category: categoryEngine,
			parser: (String response) {
				if (response.startsWith('41 0E')) {
					var byte = response.substring(6).trim();
					return int.parse(byte, radix: 16) - 128;
				}
				return null;
			},
		),

		'speed': ObdParameter(
			key: 'speed',
			pid: '010D',
			name: 'Скорость',
			unit: 'км/ч',
			category: categoryMovement,
			parser: (String response) {
				if (response.startsWith('41 0D')) {
					var byte = response.substring(6).trim();
					return int.parse(byte, radix: 16);
				}
				return null;
			},
		),

		'throttle': ObdParameter(
			key: 'throttle',
			pid: '0111',
			name: 'Положение дросселя',
			unit: '%',
			category: categoryMovement,
			parser: (String response) {
				if (response.startsWith('41 11')) {
					var byte = response.substring(6).trim();
					return (int.parse(byte, radix: 16) * 100) / 255;
				}
				return null;
			},
		),

		'maf': ObdParameter(
			key: 'maf',
			pid: '0110',
			name: 'Расход воздуха',
			unit: 'г/с',
			category: categoryEngine,
			parser: (String response) {
				if (response.startsWith('41 10')) {
					var bytes = response.substring(6).trim().split(' ');
					if (bytes.length >= 2) {
						int a = int.parse(bytes[0], radix: 16);
						int b = int.parse(bytes[1], radix: 16);
						return ((a * 256) + b) / 100;
					}
				}
				return null;
			},
		),

		'o2Voltage': ObdParameter(
			key: 'o2Voltage',
			pid: '0124',
			name: 'Напряжение O2',
			unit: 'В',
			category: categoryFuel,
			parser: (String response) {
				if (response.startsWith('41 24')) {
					var bytes = response.substring(6).trim().split(' ');
					if (bytes.length >= 2) {
						int a = int.parse(bytes[0], radix: 16);
						return a / 200;
					}
				}
				return null;
			},
		),

		'engineOilTemp': ObdParameter(
			key: 'engineOilTemp',
			pid: '015C',
			name: 'Температура масла',
			unit: '°C',
			category: categoryEngine,
			parser: (String response) {
				if (response.startsWith('41 5C')) {
					var byte = response.substring(6).trim();
					return int.parse(byte, radix: 16) - 40;
				}
				return null;
			},
		),

		'engineRuntime': ObdParameter(
			key: 'engineRuntime',
			pid: '011F',
			name: 'Время работы',
			unit: 'сек',
			category: categoryEngine,
			parser: (String response) {
				if (response.startsWith('41 1F')) {
					var bytes = response.substring(6).trim().split(' ');
					if (bytes.length >= 2) {
						int a = int.parse(bytes[0], radix: 16);
						int b = int.parse(bytes[1], radix: 16);
						return (a * 256) + b;
					}
				}
				return null;
			},
		),

		'fuelPressure': ObdParameter(
			key: 'fuelPressure',
			pid: '010A',
			name: 'Давление топлива',
			unit: 'kPa',
			category: categoryFuel,
			parser: (String response) {
				if (response.startsWith('41 0A')) {
					var byte = response.substring(6).trim();
					return int.parse(byte, radix: 16) * 3;
				}
				return null;
			},
		),

		'turboBoost': ObdParameter(
			key: 'turboBoost',
			pid: '0170',
			name: 'Давление турбины',
			unit: 'PSI',
			category: categoryEngine,
			parser: (String response) {
				if (response.startsWith('41 70')) {
					var bytes = response.substring(6).trim().split(' ');
					if (bytes.length >= 2) {
						int a = int.parse(bytes[0], radix: 16);
						int b = int.parse(bytes[1], radix: 16);
						return ((a * 256) + b) / 14.504;
					}
				}
				return null;
			},
		),

		'wheelSpeed': ObdParameter(
			key: 'wheelSpeed',
			pid: '0144',
			name: 'Скорость колёс',
			unit: 'км/ч',
			category: categoryMovement,
			parser: (String response) {
				if (response.startsWith('41 44')) {
					var byte = response.substring(6).trim();
					return int.parse(byte, radix: 16);
				}
				return null;
			},
		),

		'intakeTemp': ObdParameter(
			key: 'intakeTemp',
			pid: '010F',
			name: 'Температура впуска',
			unit: '°C',
			category: categoryEngine,
			parser: (String response) {
				if (response.startsWith('41 0F')) {
					var byte = response.substring(6).trim();
					return int.parse(byte, radix: 16) - 40;
				}
				return null;
			},
		),

		'fuelLevel': ObdParameter(
			key: 'fuelLevel',
			pid: '012F',
			name: 'Уровень топлива',
			unit: '%',
			category: categoryFuel,
			parser: (String response) {
				if (response.startsWith('41 2F')) {
					var byte = response.substring(6).trim();
					return (int.parse(byte, radix: 16) * 100) / 255;
				}
				return null;
			},
		),

		'batteryVoltage': ObdParameter(
			key: 'batteryVoltage',
			pid: '0142',
			name: 'Напряжение АКБ',
			unit: 'В',
			category: categoryElectrical,
			parser: (String response) {
				if (response.startsWith('41 42')) {
					var bytes = response.substring(6).trim().split(' ');
					if (bytes.length >= 2) {
						int a = int.parse(bytes[0], radix: 16);
						int b = int.parse(bytes[1], radix: 16);
						return ((a * 256) + b) / 1000;
					}
				}
				return null;
			},
		),

		'ambientTemp': ObdParameter(
			key: 'ambientTemp',
			pid: '0146',
			name: 'Температура воздуха',
			unit: '°C',
			category: categoryEngine,
			parser: (String response) {
				if (response.startsWith('41 46')) {
					var byte = response.substring(6).trim();
					return int.parse(byte, radix: 16) - 40;
				}
				return null;
			},
		),
	};

	static List<ObdParameter> getParametersByCategory(String category) {
		return parameters.values
				.where((param) => param.category == category)
				.toList();
	}
} 