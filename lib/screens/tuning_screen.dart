import 'package:flutter/material.dart';

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
          'Двигатель',
          Icons.directions_car_outlined,
          [
            _buildTuningOption(
              context,
              'Прошивка дросселя',
              'Настройка отклика педали газа',
              Icons.speed,
              () => _showTuningDialog(context, 'throttle'),
            ),
            _buildTuningOption(
              context,
              'Ограничитель оборотов',
              'Настройка максимальных оборотов',
              Icons.trending_up,
              () => _showTuningDialog(context, 'rpm_limit'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildTuningGroup(
          context,
          'Топливная система',
          Icons.local_gas_station_outlined,
          [
            _buildTuningOption(
              context,
              'Состав смеси',
              'Настройка богатства смеси',
              Icons.opacity,
              () => _showTuningDialog(context, 'fuel_mixture'),
            ),
            _buildTuningOption(
              context,
              'Давление турбины',
              'Настройка давления наддува',
              Icons.compress,
              () => _showTuningDialog(context, 'boost_pressure'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildTuningGroup(
          context,
          'Трансмиссия',
          Icons.settings_outlined,
          [
            _buildTuningOption(
              context,
              'Точки переключения',
              'Настройка моментов переключения передач',
              Icons.swap_vert,
              () => _showTuningDialog(context, 'shift_points'),
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

  Widget _buildTuningOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
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
              icon,
              color: Theme.of(context).colorScheme.primary,
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
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.outline,
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