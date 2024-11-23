import 'package:flutter/material.dart';
import 'package:x_obd_project/data/obd_parameters.dart';
import 'package:x_obd_project/obd/wifi_obd_controller.dart';

class SensorsScreen extends StatefulWidget {
	final Map<String, dynamic> data;
	final WifiObdController obdController;

	const SensorsScreen({
		super.key,
		required this.data,
		required this.obdController,
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
		widget.obdController.startPeriodicUpdates(); // Запускаем обновления
	}

	void _subscribeToData() {
		widget.obdController.dataStream.listen((data) {
			if (mounted) {
				setState(() {
					currentData.addAll(data);
				});
			}
		});
	}

	@override
	void dispose() {
		widget.obdController.stopPeriodicUpdates(); // Останавливаем обновления
		super.dispose();
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
		final engineParams = ObdParameters.getParametersByCategory(ObdParameters.categoryEngine);
		final movementParams = ObdParameters.getParametersByCategory(ObdParameters.categoryMovement);
		final fuelParams = ObdParameters.getParametersByCategory(ObdParameters.categoryFuel);
		final electricalParams = ObdParameters.getParametersByCategory(ObdParameters.categoryElectrical);

		return Column(
			children: [
				_buildSensorGroup(
					context,
					'Двигатель',
					Icons.directions_car_outlined,
					engineParams.map((param) => _buildSensorItem(
						context,
						param.name,
						'${currentData[param.key] ?? "0"}',
						param.unit,
					)).toList(),
				),
				const SizedBox(height: 24),
				_buildSensorGroup(
					context,
					'Движение',
					Icons.speed_outlined,
					movementParams.map((param) => _buildSensorItem(
						context,
						param.name,
						'${currentData[param.key] ?? "0"}',
						param.unit,
					)).toList(),
				),
				const SizedBox(height: 24),
				_buildSensorGroup(
					context,
					'Топливная система',
					Icons.local_gas_station_outlined,
					fuelParams.map((param) => _buildSensorItem(
						context,
						param.name,
						'${currentData[param.key] ?? "0"}',
						param.unit,
					)).toList(),
				),
				const SizedBox(height: 24),
				_buildSensorGroup(
					context,
					'Электрика',
					Icons.electric_bolt_outlined,
					electricalParams.map((param) => _buildSensorItem(
						context,
						param.name,
						'${currentData[param.key] ?? "0"}',
						param.unit,
					)).toList(),
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