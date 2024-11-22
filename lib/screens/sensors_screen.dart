import 'package:flutter/material.dart';

class SensorsScreen extends StatelessWidget {
	final Map<String, dynamic> data;

	const SensorsScreen({super.key, required this.data});

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
						_buildSensorItem(context, 'RPM', '${data['rpm'] ?? "0"}', 'об/мин'),
						_buildSensorItem(
							context,
							'Нагрузка',
							'${data['engineLoad']?.toStringAsFixed(1) ?? "0"}',
							'%',
						),
						_buildSensorItem(
							context,
							'Температура',
							'${data['temp'] ?? "0"}',
							'°C',
						),
					],
				),
				const SizedBox(height: 24),
				_buildSensorGroup(
					context,
					'Топливная система',
					Icons.local_gas_station_outlined,
					[
						_buildSensorItem(
							context,
							'Уровень топлива',
							'${data['fuelLevel']?.toStringAsFixed(1) ?? "0"}',
							'%',
						),
						_buildSensorItem(
							context,
							'Расход топлива',
							'N/A',
							'л/100км',
						),
					],
				),
				const SizedBox(height: 24),
				_buildSensorGroup(
					context,
					'Электрика',
					Icons.electric_bolt_outlined,
					[
						_buildSensorItem(
							context,
							'Напряжение',
							'${data['voltage']?.toStringAsFixed(1) ?? "0"}',
							'В',
						),
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