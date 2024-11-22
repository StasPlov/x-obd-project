import 'package:flutter/material.dart';

class BackupScreen extends StatelessWidget {
	const BackupScreen({super.key});

	@override
	Widget build(BuildContext context) {
		final colorScheme = Theme.of(context).colorScheme;
		
		return Scaffold(
			backgroundColor: colorScheme.surface,
			appBar: AppBar(
				backgroundColor: Colors.transparent,
				elevation: 0,
				centerTitle: true,
				title: const Text('Резервное копирование'),
			),
			body: CustomScrollView(
				slivers: [
					SliverToBoxAdapter(
						child: Padding(
							padding: const EdgeInsets.all(16),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									_buildBackupStatus(context),
									const SizedBox(height: 24),
									_buildBackupsList(context),
								],
							),
						),
					),
				],
			),
			floatingActionButton: FloatingActionButton.extended(
				onPressed: () => _createBackup(context),
				icon: const Icon(Icons.backup),
				label: const Text('Создать backup'),
			),
		);
	}

	Widget _buildBackupStatus(BuildContext context) {
		return Container(
			padding: const EdgeInsets.all(20),
			decoration: BoxDecoration(
				gradient: LinearGradient(
					colors: [
						Theme.of(context).colorScheme.primaryContainer,
						Theme.of(context).colorScheme.secondaryContainer,
					],
					begin: Alignment.topLeft,
					end: Alignment.bottomRight,
				),
				borderRadius: BorderRadius.circular(20),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: [
							const Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										'Последний backup',
										style: TextStyle(
											fontSize: 16,
											color: Colors.white70,
										),
									),
									SizedBox(height: 8),
									Text(
										'2 дня назад',
										style: TextStyle(
											fontSize: 24,
											fontWeight: FontWeight.bold,
											color: Colors.white,
										),
									),
								],
							),
							Container(
								padding: const EdgeInsets.all(12),
								decoration: BoxDecoration(
									color: Colors.white.withOpacity(0.2),
									borderRadius: BorderRadius.circular(12),
								),
								child: const Icon(
									Icons.backup,
									color: Colors.white,
									size: 32,
								),
							),
						],
					),
				],
			),
		);
	}

	Widget _buildBackupsList(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const Padding(
					padding: EdgeInsets.only(left: 4, bottom: 12),
					child: Text(
						'История backup\'ов',
						style: TextStyle(
							fontSize: 16,
							fontWeight: FontWeight.bold,
						),
					),
				),
				_buildBackupItem(
					context,
					'Backup перед Stage 1',
					'Stock configuration',
					DateTime.now().subtract(const Duration(days: 2)),
					'2.3 MB',
				),
				const SizedBox(height: 12),
				_buildBackupItem(
					context,
					'Автоматический backup',
					'Stage 1 configuration',
					DateTime.now().subtract(const Duration(days: 1)),
					'2.3 MB',
				),
			],
		);
	}

	Widget _buildBackupItem(
		BuildContext context,
		String title,
		String description,
		DateTime date,
		String size,
	) {
		return Container(
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration(
				color: Theme.of(context).colorScheme.surfaceContainerHighest,
				borderRadius: BorderRadius.circular(16),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: [
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											title,
											style: const TextStyle(
												fontWeight: FontWeight.bold,
											),
										),
										const SizedBox(height: 4),
										Text(
											description,
											style: TextStyle(
												color: Theme.of(context).colorScheme.onSurfaceVariant,
											),
										),
										const SizedBox(height: 4),
										Text(
											'${date.day}.${date.month}.${date.year} • $size',
											style: TextStyle(
												fontSize: 12,
												color: Theme.of(context).colorScheme.outline,
											),
										),
									],
								),
							),
							PopupMenuButton(
								itemBuilder: (context) => [
									const PopupMenuItem(
										value: 'restore',
										child: Text('Восстановить'),
									),
									const PopupMenuItem(
										value: 'download',
										child: Text('Скачать'),
									),
									const PopupMenuItem(
										value: 'delete',
										child: Text('Удалить'),
									),
								],
								onSelected: (value) {
									// TODO: Обработка действий с бэкапом
								},
							),
						],
					),
				],
			),
		);
	}

	void _createBackup(BuildContext context) {
		showDialog(
			context: context,
			builder: (context) => AlertDialog(
				title: const Text('Создание backup\'а'),
				content: const Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						TextField(
							decoration: InputDecoration(
								labelText: 'Название',
								hintText: 'Введите название backup\'а',
							),
						),
						SizedBox(height: 16),
						TextField(
							decoration: InputDecoration(
								labelText: 'Описание',
								hintText: 'Введите описание backup\'а',
							),
							maxLines: 3,
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
							// TODO: Создание backup'а
							Navigator.pop(context);
						},
						child: const Text('Создать'),
					),
				],
			),
		);
	}
}