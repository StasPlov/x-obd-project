import '../models/vehicle.dart';

class InfinitiModels {
	// Базовые параметры, поддерживаемые всеми двигателями
	static const List<String> baseParameters = [
		'rpm',
		'speed',
		'coolantTemp',
		'engineLoad',
		'throttle',
		'shortFuelTrim1',
		'shortFuelTrim2',
		'longFuelTrim1',
		'longFuelTrim2',
		'manifoldPressure',
		'timingAdvance',
		'intakeTemp',
		'airFlowRate',
		'oxygenSensor1',
		'batteryVoltage',
		'distanceMIL',
	];

	// Параметры для атмосферных двигателей (VQ)
	static const List<String> vqParameters = [
		...baseParameters,
		'engineOilTemp',
		'fuelPressure',
		'evapPurge',
		'commandedEGR',
		'obdStandards',
	];

	// Параметры для турбированных двигателей (VR)
	static const List<String> vrParameters = [
		...vqParameters,
		'turboBoost',
		'fuelRailPressure',
	];

	// Обновляем списки параметров для конкретных двигателей
	static const List<String> vq35deParameters = [
		...vqParameters,
	];

	static const List<String> vq37vhrParameters = [
		...vqParameters,
		'wheelSpeed',
	];

	static const List<String> vr30ddttParameters = [
		...vrParameters,
	];

	static final List<Vehicle> models = [
		const Vehicle(
			make: 'Infiniti',
			model: 'FX35',
			year: '2003-2008',
			engine: 'VQ35DE',
			supportedParameterKeys: vq35deParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'FX37',
			year: '2009-2013',
			engine: 'VQ37VHR',
			supportedParameterKeys: vq37vhrParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'G35',
			year: '2003-2008',
			engine: 'VQ35DE',
			supportedParameterKeys: vq35deParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'G37',
			year: '2008-2013',
			engine: 'VQ37VHR',
			supportedParameterKeys: vq37vhrParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'Q50',
			year: '2014-2023',
			engine: 'VR30DDTT',
			supportedParameterKeys: vr30ddttParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'Q60',
			year: '2014-2023',
			engine: 'VR30DDTT',
			supportedParameterKeys: vr30ddttParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'M35',
			year: '2006-2010',
			engine: 'VQ35DE',
			supportedParameterKeys: vq35deParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'M37',
			year: '2011-2013',
			engine: 'VQ37VHR',
			supportedParameterKeys: vq37vhrParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'EX35',
			year: '2008-2012',
			engine: 'VQ35HR',
			supportedParameterKeys: vq35deParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'EX37',
			year: '2013',
			engine: 'VQ37VHR',
			supportedParameterKeys: vq37vhrParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'Q70',
			year: '2014-2019',
			engine: 'VQ37VHR',
			supportedParameterKeys: vq37vhrParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'QX50',
			year: '2014-2017',
			engine: 'VQ37VHR',
			supportedParameterKeys: vq37vhrParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'QX60',
			year: '2014-2023',
			engine: 'VQ35DE',
			supportedParameterKeys: vq35deParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'QX70',
			year: '2014-2017',
			engine: 'VQ37VHR',
			supportedParameterKeys: vq37vhrParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'JX35',
			year: '2013',
			engine: 'VQ35DE',
			supportedParameterKeys: vq35deParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'FX50',
			year: '2009-2013',
			engine: 'VK50VE',
			supportedParameterKeys: vq37vhrParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'M56',
			year: '2011-2013',
			engine: 'VK56VD',
			supportedParameterKeys: vq37vhrParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'Q70',
			year: '2014-2019',
			engine: 'VK56VD',
			supportedParameterKeys: vq37vhrParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'QX56',
			year: '2004-2010',
			engine: 'VK56DE',
			supportedParameterKeys: vq35deParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'QX56',
			year: '2011-2013',
			engine: 'VK56VD',
			supportedParameterKeys: vq37vhrParameters,
		),
		const Vehicle(
			make: 'Infiniti',
			model: 'QX80',
			year: '2014-2023',
			engine: 'VK56VD',
			supportedParameterKeys: vq37vhrParameters,
		),
	];
} 