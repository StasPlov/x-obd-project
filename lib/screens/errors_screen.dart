import 'package:flutter/material.dart';

class ErrorsScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const ErrorsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Ошибки'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildErrorsSummaryCard(context),
                  const SizedBox(height: 24),
                  _buildErrorsList(context),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Реализовать сброс ошибок
        },
        icon: const Icon(Icons.refresh),
        label: const Text('Сбросить ошибки'),
      ),
    );
  }

  Widget _buildErrorsSummaryCard(BuildContext context) {
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '2 ошибки',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Требуется внимание',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.warning_amber_rounded,
                size: 48,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Активные ошибки',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildErrorItem(
          context,
          'P0301',
          'Пропуски зажигания в 1-м цилиндре',
          'Критическая',
        ),
        _buildErrorItem(
          context,
          'P0420',
          'Эффективность системы катализатора ниже порога',
          'Средняя',
        ),
      ],
    );
  }

  Widget _buildErrorItem(
    BuildContext context,
    String code,
    String description,
    String severity,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          children: [
            Text(
              code,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: severity == 'Критическая'
                    ? Colors.red.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                severity,
                style: TextStyle(
                  fontSize: 12,
                  color: severity == 'Критическая'
                      ? Colors.red
                      : Colors.orange,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(description),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Показать детали ошибки
        },
      ),
    );
  }
} 