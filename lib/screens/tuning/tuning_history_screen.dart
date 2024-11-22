import 'package:flutter/material.dart';

class TuningHistoryScreen extends StatelessWidget {
	const TuningHistoryScreen({super.key});

	@override
	Widget build(BuildContext context) {
		final colorScheme = Theme.of(context).colorScheme;
		
		return Scaffold(
			backgroundColor: colorScheme.surface,
			appBar: AppBar(
				backgroundColor: Colors.transparent,
				elevation: 0,
				centerTitle: true,
				title: const Text('История изменений'),
			),
			body: CustomScrollView(
				slivers: [
					SliverToBoxAdapter(
						child: Padding(
							padding: const EdgeInsets.all(16),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									_buildHistorySummary(context),
									const SizedBox(height: 24),
									_buildHistoryTimeline(context),
								],
							),
						),
					),
				],
			),
		);
	}

	Widget _buildHistorySummary(BuildContext context) {
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
					const Text(
						'Всего изменений',
						style: TextStyle(
							fontSize: 16,
							color: Colors.white70,
						),
					),
					const SizedBox(height: 8),
					const Text(
						'12',
						style: TextStyle(
							fontSize: 36,
							fontWeight: FontWeight.bold,
							color: Colors.white,
						),
					),
					const SizedBox(height: 16),
					Container(
						padding: const EdgeInsets.symmetric(
							horizontal: 12,
							vertical: 6,
						),
						decoration: BoxDecoration(
							color: Colors.white.withOpacity(0.2),
							borderRadius: BorderRadius.circular(20),
						),
						child: const Text(
							'Последнее изменение: 2 дня назад',
							style: TextStyle(
								color: Colors.white,
								fontSize: 12,
							),
						),
					),
				],
			),
		);
	}

	Widget _buildHistoryTimeline(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const Padding(
					padding: EdgeInsets.only(left: 4, bottom: 12),
					child: Text(
						'История',
						style: TextStyle(
							fontSize: 16,
							fontWeight: FontWeight.bold,
						),
					),
				),
				_buildHistoryItem(
					context,
					'Установка Stage 1',
					'Увеличение мощности и крутящего момента',
					DateTime.now().subtract(const Duration(days: 2)),
					HistoryItemType.tuning,
				),
				const SizedBox(height: 12),
				_buildHistoryItem(
					context,
					'Диагностика',
					'Проверка параметров после прошивки',
					DateTime.now().subtract(const Duration(days: 2)),
					HistoryItemType.diagnostics,
				),
				const SizedBox(height: 12),
				_buildHistoryItem(
					context,
					'Backup',
					'Создание резервной копии',
					DateTime.now().subtract(const Duration(days: 3)),
					HistoryItemType.backup,
				),
			],
		);
	}

	Widget _buildHistoryItem(
		BuildContext context,
		String title,
		String description,
		DateTime date,
		HistoryItemType type,
	) {
		return Container(
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration(
				color: Theme.of(context).colorScheme.surfaceContainerHighest,
				borderRadius: BorderRadius.circular(16),
			),
			child: Row(
				children: [
					Container(
						padding: const EdgeInsets.all(8),
						decoration: BoxDecoration(
							color: _getTypeColor(type).withOpacity(0.1),
							borderRadius: BorderRadius.circular(8),
						),
						child: Icon(
							_getTypeIcon(type),
							color: _getTypeColor(type),
						),
					),
					const SizedBox(width: 16),
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
									'${date.day}.${date.month}.${date.year}',
									style: TextStyle(
										fontSize: 12,
										color: Theme.of(context).colorScheme.outline,
									),
								),
							],
						),
					),
				],
			),
		);
	}

	Color _getTypeColor(HistoryItemType type) {
		switch (type) {
			case HistoryItemType.tuning:
				return Colors.blue;
			case HistoryItemType.diagnostics:
				return Colors.green;
			case HistoryItemType.backup:
				return Colors.orange;
		}
	}

	IconData _getTypeIcon(HistoryItemType type) {
		switch (type) {
			case HistoryItemType.tuning:
				return Icons.tune;
			case HistoryItemType.diagnostics:
				return Icons.analytics;
			case HistoryItemType.backup:
				return Icons.backup;
		}
	}
}

enum HistoryItemType {
	tuning,
	diagnostics,
	backup,
} 