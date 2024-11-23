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

		'shortFuelTrim1': ObdParameter(
			key: 'shortFuelTrim1',
			pid: '0106',
			name: 'Краткосрочная топливная коррекция Банк 1',
			unit: '%',
			category: categoryFuel,
			parser: (String response) {
				if (response.startsWith('41 06')) {
					var byte = response.substring(6).trim();
					return (int.parse(byte, radix: 16) - 128) * 100 / 128;
				}
				return null;
			},
		),

		'shortFuelTrim2': ObdParameter(
			key: 'shortFuelTrim2',
			pid: '0108',
			name: 'Краткосрочная топливная коррекция Банк 2',
			unit: '%',
			category: categoryFuel,
			parser: (String response) {
				if (response.startsWith('41 08')) {
					var byte = response.substring(6).trim();
					return (int.parse(byte, radix: 16) - 128) * 100 / 128;
				}
				return null;
			},
		),

		'longFuelTrim1': ObdParameter(
			key: 'longFuelTrim1',
			pid: '0107',
			name: 'Долгосрочная топливная коррекция Банк 1',
			unit: '%',
			category: categoryFuel,
			parser: (String response) {
				if (response.startsWith('41 07')) {
					var byte = response.substring(6).trim();
					return (int.parse(byte, radix: 16) - 128) * 100 / 128;
				}
				return null;
			},
		),

		'longFuelTrim2': ObdParameter(
			key: 'longFuelTrim2',
			pid: '0109',
			name: 'Долгосрочная топливная коррекция Банк 2',
			unit: '%',
			category: categoryFuel,
			parser: (String response) {
				if (response.startsWith('41 09')) {
					var byte = response.substring(6).trim();
					return (int.parse(byte, radix: 16) - 128) * 100 / 128;
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

		'manifoldPressure': ObdParameter(
			key: 'manifoldPressure',
			pid: '010B',
			name: 'Давление во впускном коллекторе',
			unit: 'kPa',
			category: categoryEngine,
			parser: (String response) {
				if (response.startsWith('41 0B')) {
					var byte = response.substring(6).trim();
					return int.parse(byte, radix: 16);
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

		'wheelSpeed': ObdParameter(
			key: 'wheelSpeed',
			pid: '0144',
			name: 'Скорость колёс',
			unit: 'км/ч',
			category: categoryMovement,
			parser: (String response) {
				if (response.startsWith('41 44')) {
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

		'fuelRailPressure': ObdParameter(
			key: 'fuelRailPressure',
			pid: '0123',
			name: 'Давление в топливной рампе',
			unit: 'kPa',
			category: categoryFuel,
			parser: (String response) {
				if (response.startsWith('41 23')) {
					var bytes = response.substring(6).trim().split(' ');
					if (bytes.length >= 2) {
						int a = int.parse(bytes[0], radix: 16);
						int b = int.parse(bytes[1], radix: 16);
						return ((a * 256) + b) * 10;
					}
				}
				return null;
			},
		),

		'commandedEGR': ObdParameter(
			key: 'commandedEGR',
			pid: '012C',
			name: 'Команда EGR',
			unit: '%',
			category: categoryExhaust,
			parser: (String response) {
				if (response.startsWith('41 2C')) {
					var byte = response.substring(6).trim();
					return (int.parse(byte, radix: 16) * 100) / 255;
				}
				return null;
			},
		),

		'evapPurge': ObdParameter(
			key: 'evapPurge',
			pid: '012E',
			name: 'Команда продувки',
			unit: '%',
			category: categoryExhaust,
			parser: (String response) {
				if (response.startsWith('41 2E')) {
					var byte = response.substring(6).trim();
					return (int.parse(byte, radix: 16) * 100) / 255;
				}
				return null;
			},
		),

		'distanceMIL': ObdParameter(
			key: 'distanceMIL',
			pid: '0121',
			name: 'Пробег с включенным MIL',
			unit: 'км',
			category: categoryEngine,
			parser: (String response) {
				if (response.startsWith('41 21')) {
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

		'airFlowRate': ObdParameter(
			key: 'airFlowRate',
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

		'oxygenSensor1': ObdParameter(
			key: 'oxygenSensor1',
			pid: '0114',
			name: 'Напряжение датчика O2 №1',
			unit: 'В',
			category: categoryExhaust,
			parser: (String response) {
				if (response.startsWith('41 14')) {
					var byte = response.substring(6).trim();
					return int.parse(byte, radix: 16) / 200;
				}
				return null;
			},
		),

		'obdStandards': ObdParameter(
			key: 'obdStandards',
			pid: '011C',
			name: 'Стандарт OBD',
			unit: '',
			category: categoryEngine,
			parser: (String response) {
				if (response.startsWith('41 1C')) {
					var byte = response.substring(6).trim();
					return int.parse(byte, radix: 16);
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

		'timingAdvance': ObdParameter(
			key: 'timingAdvance',
			pid: '010E',
			name: 'Угол опережения зажигания',
			unit: '°',
			category: categoryEngine,
			parser: (String response) {
				if (response.startsWith('41 0E')) {
					var byte = response.substring(6).trim();
					return (int.parse(byte, radix: 16) - 128) / 2;
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