import 'package:flutter/material.dart';
import 'package:x_obd_project/data/obd_parameter_keys.dart';

class SensorsScreen extends StatefulWidget {
	final Map<String, dynamic> data;
	final Stream<Map<String, dynamic>> dataStream;

	const SensorsScreen({
		super.key,
		required this.data,
		required this.dataStream,
	});

	@override
	State<SensorsScreen> createState() => _SensorsScreenState();
}

class _SensorsScreenState extends State<SensorsScreen> {
	late Map<String, dynamic> currentData;

	@override
	void initState() {
		super.initState();
		currentData = Map.from(widget.data);
		_subscribeToData();
	}

	void _subscribeToData() {
		widget.dataStream.listen((data) {
			setState(() {
				currentData.addAll(data);
			});
		});
	}

	@override
	Widget build(BuildContext context) {
		final colorScheme = Theme.of(context).colorScheme;
		
		return Scaffold(
			backgroundColor: colorScheme.surface,
			appBar: AppBar(
				backgroundColor: Colors.transparent,
				elevation: 0,
				centerTitle: true,
				title: const Text('Датчики'),
			),
			body: CustomScrollView(
				slivers: [
					SliverToBoxAdapter(
						child: Padding(
							padding: const EdgeInsets.all(16),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									_buildSensorGroups(context),
								],
							),
						),
					),
				],
			),
		);
	}

	Widget _buildSensorGroups(BuildContext context) {
		return Column(
			children: [
				_buildSensorGroup(
					context,
					'Двигатель',
					Icons.directions_car_outlined,
					[
						_buildSensorItem(context, 'RPM', '${currentData[ObdParameterKeys.rpm] ?? "0"}', 'об/мин'),
						_buildSensorItem(context, 'Нагрузка', '${currentData[ObdParameterKeys.engineLoad]?.toStringAsFixed(1) ?? "0"}', '%'),
						_buildSensorItem(context, 'Температура ОЖ', '${currentData[ObdParameterKeys.coolantTemp] ?? "0"}', '°C'),
						_buildSensorItem(context, 'Температура масла', '${currentData[ObdParameterKeys.engineOilTemp] ?? "0"}', '°C'),
						_buildSensorItem(context, 'Давление впуска', '${currentData[ObdParameterKeys.manifoldPressure] ?? "0"}', 'kPa'),
						_buildSensorItem(context, 'Время работы', '${currentData[ObdParameterKeys.engineRuntime] ?? "0"}', 'сек'),
						_buildSensorItem(context, 'Угол опережения', '${currentData[ObdParameterKeys.timing] ?? "0"}', '°'),
						_buildSensorItem(context, 'Температура впуска', '${currentData[ObdParameterKeys.intakeTemp] ?? "0"}', '°C'),
						_buildSensorItem(context, 'Крутящий момент', '${currentData[ObdParameterKeys.engineTorque] ?? "0"}', 'Нм'),
						_buildSensorItem(context, 'Давление масла', '${currentData[ObdParameterKeys.oilPressure] ?? "0"}', 'kPa'),
						_buildSensorItem(context, 'Ресурс масла', '${currentData[ObdParameterKeys.engineOilLife] ?? "0"}', '%'),
						_buildSensorItem(context, 'Давление турбины', '${currentData[ObdParameterKeys.turboBoost] ?? "0"}', 'PSI'),
					],
				),
				const SizedBox(height: 24),
				_buildSensorGroup(
					context,
					'Движение',
					Icons.speed_outlined,
					[
						_buildSensorItem(context, 'Скорость', '${currentData[ObdParameterKeys.speed] ?? "0"}', 'км/ч'),
						_buildSensorItem(context, 'Положение дросселя', '${currentData[ObdParameterKeys.throttle]?.toStringAsFixed(1) ?? "0"}', '%'),
						_buildSensorItem(context, 'Абсолютное положение', '${currentData[ObdParameterKeys.absThrottle]?.toStringAsFixed(1) ?? "0"}', '%'),
						_buildSensorItem(context, 'Скорость колёс', '${currentData[ObdParameterKeys.wheelSpeed] ?? "0"}', 'км/ч'),
						_buildSensorItem(context, 'Ускорение X', '${currentData[ObdParameterKeys.accelerationX]?.toStringAsFixed(2) ?? "0"}', 'g'),
						_buildSensorItem(context, 'Ускорение Y', '${currentData[ObdParameterKeys.accelerationY]?.toStringAsFixed(2) ?? "0"}', 'g'),
						_buildSensorItem(context, 'Угол руля', '${currentData[ObdParameterKeys.steeringAngle] ?? "0"}', '°'),
					],
				),
				const SizedBox(height: 24),
				_buildSensorGroup(
					context,
					'Топливная система',
						Icons.local_gas_station_outlined,
					[
						_buildSensorItem(context, 'Уровень топлива', '${currentData[ObdParameterKeys.fuelLevel]?.toStringAsFixed(1) ?? "0"}', '%'),
						_buildSensorItem(context, 'Расход воздуха', '${currentData[ObdParameterKeys.maf]?.toStringAsFixed(1) ?? "0"}', 'г/с'),
						_buildSensorItem(context, 'Напряжение O2', '${currentData[ObdParameterKeys.o2Voltage]?.toStringAsFixed(2) ?? "0"}', 'В'),
						_buildSensorItem(context, 'Давление топлива', '${currentData[ObdParameterKeys.fuelPressure] ?? "0"}', 'kPa'),
						_buildSensorItem(context, 'Давление в рампе', '${currentData[ObdParameterKeys.fuelRailPressure] ?? "0"}', 'kPa'),
						_buildSensorItem(context, 'Расход топлива', '${currentData[ObdParameterKeys.fuelConsumption]?.toStringAsFixed(1) ?? "0"}', 'л/100км'),
						_buildSensorItem(context, 'Коррекция топлива', '${currentData[ObdParameterKeys.fuelTrim]?.toStringAsFixed(1) ?? "0"}', '%'),
						_buildSensorItem(context, 'Тип топлива', '${currentData[ObdParameterKeys.fuelType] ?? "N/A"}', ''),
						_buildSensorItem(context, 'Содержание этанола', '${currentData[ObdParameterKeys.ethanolPercent] ?? "0"}', '%'),
						_buildSensorItem(context, 'Расход в час', '${currentData[ObdParameterKeys.fuelRate]?.toStringAsFixed(1) ?? "0"}', 'л/ч'),
					],
				),
				const SizedBox(height: 24),
				_buildSensorGroup(
					context,
					'Электрика',
					Icons.electric_bolt_outlined,
					[
						_buildSensorItem(context, 'Напряжение', '${currentData[ObdParameterKeys.voltage]?.toStringAsFixed(1) ?? "0"}', 'В'),
						_buildSensorItem(context, 'Напряжение АКБ', '${currentData[ObdParameterKeys.batteryVoltage]?.toStringAsFixed(1) ?? "0"}', 'В'),
						_buildSensorItem(context, 'Напряжение генератора', '${currentData[ObdParameterKeys.alternatorVoltage]?.toStringAsFixed(1) ?? "0"}', 'В'),
						_buildSensorItem(context, 'Температура АКБ', '${currentData[ObdParameterKeys.batteryTemp] ?? "0"}', '°C'),
						_buildSensorItem(context, 'Заряд АКБ', '${currentData[ObdParameterKeys.batteryCharge] ?? "0"}', '%'),
						_buildSensorItem(context, 'Нагрузка генератора', '${currentData[ObdParameterKeys.alternatorLoad] ?? "0"}', '%'),
					],
				),
				const SizedBox(height: 24),
				_buildSensorGroup(
					context,
					'Трансмиссия',
					Icons.settings_outlined,
					[
						_buildSensorItem(context, 'Температура АКПП', '${currentData[ObdParameterKeys.transmissionTemp] ?? "0"}', '°C'),
						_buildSensorItem(context, 'Текущая передача', '${currentData[ObdParameterKeys.currentGear] ?? "N/A"}', ''),
						_buildSensorItem(context, 'Гидротрансформатор', '${currentData[ObdParameterKeys.torqueConverter] ?? "0"}', '%'),
						_buildSensorItem(context, 'Пробуксовка', '${currentData[ObdParameterKeys.transmissionSlip]?.toStringAsFixed(1) ?? "0"}', '%'),
						_buildSensorItem(context, 'Положение сцепления', '${currentData[ObdParameterKeys.clutchPosition] ?? "0"}', '%'),
					],
				),
				const SizedBox(height: 24),
				_buildSensorGroup(
					context,
					'Выхлопная система',
					Icons.air_outlined,
					[
						_buildSensorItem(context, 'Температура катализатора', '${currentData[ObdParameterKeys.catalystTemp] ?? "0"}', '°C'),
						_buildSensorItem(context, 'Температура выхлопа', '${currentData[ObdParameterKeys.exhaustGasTemp] ?? "0"}', '°C'),
						_buildSensorItem(context, 'NOx датчик', '${currentData[ObdParameterKeys.noxSensor] ?? "0"}', 'ppm'),
						_buildSensorItem(context, 'Сажевый фильтр', '${currentData[ObdParameterKeys.particulateFilter] ?? "0"}', '%'),
						_buildSensorItem(context, 'EGR клапан', '${currentData[ObdParameterKeys.egr] ?? "0"}', '%'),
					],
				),
			],
		);
	}

	Widget _buildSensorGroup(
		BuildContext context,
		String title,
		IconData icon,
		List<Widget> sensors,
	) {
		return Container(
			decoration: BoxDecoration(
				color: Theme.of(context).colorScheme.surfaceContainerHighest,
				borderRadius: BorderRadius.circular(20),
			),
			child: Column(
				children: [
					Padding(
						padding: const EdgeInsets.all(16),
						child: Row(
							children: [
								Icon(
									icon,
									color: Theme.of(context).colorScheme.primary,
								),
								const SizedBox(width: 12),
								Text(
									title,
									style: const TextStyle(
										fontSize: 18,
										fontWeight: FontWeight.bold,
									),
								),
							],
						),
					),
					const Divider(height: 1),
					...sensors,
				],
			),
		);
	}

	Widget _buildSensorItem(
		BuildContext context,
		String name,
		String value,
		String unit,
	) {
		return Container(
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration(
				border: Border(
					bottom: BorderSide(
						color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
					),
				),
			),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					Text(
						name,
						style: TextStyle(
							color: Theme.of(context).colorScheme.onSurfaceVariant,
						),
					),
					Text(
						'$value $unit',
						style: const TextStyle(
							fontSize: 16,
							fontWeight: FontWeight.bold,
						),
					),
				],
			),
		);
	}
} 