import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
	const SettingsScreen({super.key});

	@override
	Widget build(BuildContext context) {
		final colorScheme = Theme.of(context).colorScheme;
		
		return Scaffold(
			backgroundColor: colorScheme.surface,
			appBar: AppBar(
				backgroundColor: Colors.transparent,
				elevation: 0,
				centerTitle: true,
				title: const Text('Настройки'),
			),
			body: CustomScrollView(
				slivers: [
					SliverToBoxAdapter(
						child: Padding(
							padding: const EdgeInsets.all(16),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									_buildConnectionSettings(context),
									const SizedBox(height: 24),
									_buildAppSettings(context),
								],
							),
						),
					),
				],
			),
		);
	}

	Widget _buildConnectionSettings(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const Padding(
					padding: EdgeInsets.only(left: 16, bottom: 8),
					child: Text(
						'Подключение',
						style: TextStyle(
							fontSize: 14,
							fontWeight: FontWeight.bold,
							color: Colors.grey,
						),
					),
				),
				Container(
					decoration: BoxDecoration(
						color: Theme.of(context).colorScheme.surfaceContainerHighest,
						borderRadius: BorderRadius.circular(16),
					),
					child: Column(
						children: [
							ListTile(
								title: const Text('WiFi адрес'),
								subtitle: const Text('192.168.0.10'),
								trailing: const Icon(Icons.edit_outlined),
								onTap: () {
									// TODO: Изменить адрес
								},
							),
							const Divider(height: 1),
							ListTile(
								title: const Text('Порт'),
								subtitle: const Text('35000'),
								trailing: const Icon(Icons.edit_outlined),
								onTap: () {
									// TODO: Изменить порт
								},
							),
							const Divider(height: 1),
							ListTile(
								title: const Text('Протокол'),
								subtitle: const Text('Автоматический'),
								trailing: const Icon(Icons.keyboard_arrow_right),
								onTap: () {
									// TODO: Выбор протокола
								},
							),
						],
					),
				),
			],
		);
	}

	Widget _buildAppSettings(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const Padding(
					padding: EdgeInsets.only(left: 16, bottom: 8),
					child: Text(
						'Приложение',
						style: TextStyle(
							fontSize: 14,
							fontWeight: FontWeight.bold,
							color: Colors.grey,
						),
					),
				),
				Container(
					decoration: BoxDecoration(
						color: Theme.of(context).colorScheme.surfaceContainerHighest,
						borderRadius: BorderRadius.circular(16),
					),
					child: Column(
						children: [
							SwitchListTile(
								title: const Text('Темная тема'),
								value: false,
								onChanged: (value) {
									// TODO: Переключить тему
								},
							),
							const Divider(height: 1),
							ListTile(
								title: const Text('Частота обновления'),
								subtitle: const Text('100 мс'),
								trailing: const Icon(Icons.keyboard_arrow_right),
								onTap: () {
									// TODO: Изменить частоту
								},
							),
							const Divider(height: 1),
							ListTile(
								title: const Text('О приложении'),
								trailing: const Icon(Icons.keyboard_arrow_right),
								onTap: () {
									// TODO: Показать информацию
								},
							),
						],
					),
				),
			],
		);
	}
} 