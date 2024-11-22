import 'package:flutter/material.dart';
import 'tuning/backup_screen.dart';
import 'tuning/parameters_comparison_screen.dart';
import 'tuning/post_tuning_diagnostics_screen.dart';
import 'tuning/saved_configs_screen.dart';
import 'tuning/tuning_history_screen.dart';

class TuningScreen extends StatelessWidget {
	final Map<String, dynamic> data;

	const TuningScreen({super.key, required this.data});

	@override
	Widget build(BuildContext context) {
		final colorScheme = Theme.of(context).colorScheme;
		
		return Scaffold(
			backgroundColor: colorScheme.surface,
			appBar: AppBar(
				backgroundColor: Colors.transparent,
				elevation: 0,
				centerTitle: true,
				title: const Text('Тюнинг'),
			),
			body: CustomScrollView(
				slivers: [
					SliverToBoxAdapter(
						child: Padding(
							padding: const EdgeInsets.all(16),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									_buildWarningCard(context),
									const SizedBox(height: 24),
									_buildTuningGroups(context),
								],
							),
						),
					),
				],
			),
		);
	}

	Widget _buildWarningCard(BuildContext context) {
		return Container(
			padding: const EdgeInsets.all(20),
			decoration: BoxDecoration(
				gradient: LinearGradient(
					colors: [
						Theme.of(context).colorScheme.errorContainer,
						Theme.of(context).colorScheme.error.withOpacity(0.7),
					],
					begin: Alignment.topLeft,
					end: Alignment.bottomRight,
				),
				borderRadius: BorderRadius.circular(20),
			),
			child: const Column(
				children: [
					Row(
						children: [
							Icon(
								Icons.warning_rounded,
								color: Colors.white,
								size: 32,
							),
							SizedBox(width: 12),
							Expanded(
								child: Text(
									'Внимание! Изменение параметров может повлиять на работу двигателя',
									style: TextStyle(
										color: Colors.white,
										fontSize: 16,
										fontWeight: FontWeight.bold,
									),
								),
							),
						],
					),
				],
			),
		);
	}

	Widget _buildTuningGroups(BuildContext context) {
		return Column(
			children: [
				_buildTuningGroup(
					context,
					'Конфигурации',
					Icons.save_outlined,
					[
						_buildTuningItem(
							context,
							'Сохраненные конфигурации',
							'Управление настройками',
							() => Navigator.push(
								context,
								MaterialPageRoute(
									builder: (context) => const SavedConfigsScreen(),
								),
							),
						),
						_buildTuningItem(
							context,
							'История изменений',
							'Просмотр внесенных изменений',
							() => Navigator.push(
								context,
								MaterialPageRoute(
									builder: (context) => const TuningHistoryScreen(),
								),
							),
						),
					],
				),
				const SizedBox(height: 24),
				_buildTuningGroup(
					context,
					'Двигатель',
					Icons.directions_car_outlined,
					[
						_buildTuningItem(
							context,
							'Настройка дросселя',
							'Изменение отклика педали газа',
							() => _showTuningDialog(context, 'throttle'),
						),
						_buildTuningItem(
							context,
							'Ограничитель оборотов',
							'Настройка максимальных оборотов',
							() => _showTuningDialog(context, 'rpm_limit'),
						),
					],
				),
				const SizedBox(height: 24),
				_buildTuningGroup(
					context,
					'Диагностика',
					Icons.analytics_outlined,
					[
						_buildTuningItem(
							context,
							'Проверка после прошивки',
							'Диагностика параметров',
							() => Navigator.push(
								context,
								MaterialPageRoute(
									builder: (context) => PostTuningDiagnosticsScreen(data: data),
								),
							),
						),
						_buildTuningItem(
							context,
							'Сравнение параметров',
							'До и после изменений',
							() => Navigator.push(
								context,
								MaterialPageRoute(
									builder: (context) => ParametersComparisonScreen(
										beforeData: data,
										afterData: data, // TODO: Добавить реальные данные после
									),
								),
							),
						),
					],
				),
				const SizedBox(height: 24),
				_buildTuningGroup(
					context,
					'Резервное копирование',
					Icons.backup_outlined,
					[
						_buildTuningItem(
							context,
							'Управление backup\'ами',
							'Сохранение и восстановление',
							() => Navigator.push(
								context,
								MaterialPageRoute(
									builder: (context) => const BackupScreen(),
								),
							),
						),
					],
				),
			],
		);
	}

	Widget _buildTuningGroup(
		BuildContext context,
		String title,
		IconData icon,
		List<Widget> options,
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
					...options,
				],
			),
		);
	}

	Widget _buildTuningItem(
		BuildContext context,
		String title,
		String subtitle,
		VoidCallback onTap,
	) {
		return InkWell(
			onTap: onTap,
			child: Container(
				padding: const EdgeInsets.all(16),
				decoration: BoxDecoration(
					border: Border(
						bottom: BorderSide(
							color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
						),
					),
				),
				child: Row(
					children: [
						Icon(
							Icons.chevron_right,
							color: Theme.of(context).colorScheme.outline,
						),
						const SizedBox(width: 16),
						Expanded(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										title,
										style: const TextStyle(
											fontSize: 16,
											fontWeight: FontWeight.w500,
										),
									),
									Text(
										subtitle,
										style: TextStyle(
											fontSize: 14,
											color: Theme.of(context).colorScheme.outline,
										),
									),
								],
							),
						),
					],
				),
			),
		);
	}

	void _showTuningDialog(BuildContext context, String type) {
		showDialog(
			context: context,
			builder: (context) => AlertDialog(
				title: Text(_getTuningTitle(type)),
				content: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						_buildTuningSlider(context, type),
						const SizedBox(height: 16),
						Text(
							'Внимание: Изменение этого параметра может повлиять на работу двигателя и расход топлива.',
							style: TextStyle(
								color: Theme.of(context).colorScheme.error,
								fontSize: 12,
							),
						),
					],
				),
				actions: [
					TextButton(
						onPressed: () => Navigator.pop(context),
						child: const Text('Отмена'),
					),
					FilledButton(
						onPressed: () {
							// TODO: Реализовать сохранение настроек
							Navigator.pop(context);
						},
						child: const Text('Применить'),
					),
				],
			),
		);
	}

	String _getTuningTitle(String type) {
		switch (type) {
			case 'throttle':
				return 'Настройка дросселя';
			case 'rpm_limit':
				return 'Ограничитель оборотов';
			case 'fuel_mixture':
				return 'Состав топливной смеси';
			case 'boost_pressure':
				return 'Давление наддува';
			case 'shift_points':
				return 'Точки переключения';
			default:
				return 'Настройка';
		}
	}

	Widget _buildTuningSlider(BuildContext context, String type) {
		return StatefulBuilder(
			builder: (context, setState) {
				return Column(
					children: [
						Slider(
							value: 0.5,
							onChanged: (value) {
								setState(() {
									// TODO: Обновить значение
								});
							},
						),
						const Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Text('Стандарт'),
								Text('Спорт'),
							],
						),
					],
				);
			},
		);
	}
} 