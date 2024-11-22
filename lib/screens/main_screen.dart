import 'package:flutter/material.dart';
import 'package:x_obd_project/data/infiniti_models.dart';
import '../obd/wifi_obd_controller.dart'; // Предполагаемый путь к контроллеру
import 'errors_screen.dart';
import 'sensors_screen.dart';
import 'settings_screen.dart';
import 'tuning_screen.dart';
import 'raw_data_screen.dart';
import '../models/vehicle.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final WifiObdController _obdController = WifiObdController();
  bool isConnected = false;
  bool isConnecting = false;
  Map<String, dynamic> currentData = {};
  Vehicle? selectedVehicle;

  @override
  void initState() {
    super.initState();
    _subscribeToData();
  }

  void _subscribeToData() {
    _obdController.dataStream.listen((data) {
      setState(() {
        currentData.addAll(data);
      });
    });
  }

  Future<void> _connectToObd() async {
    if (isConnecting) return;

    setState(() {
      isConnecting = true;
    });

    try {
      await _obdController.connect();
      setState(() {
        isConnected = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Успешно подключено к OBD'),
            backgroundColor: Colors.green,
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ошибка подкючения: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isConnecting = false;
      });
    }
  }

  void _disconnectFromObd() {
    _obdController.disconnect();
    setState(() {
      isConnected = false;
      currentData.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Отключено от OBD'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<Future<Object?>> _showVehicleSelectionDialog(BuildContext context) async {
    String searchQuery = '';

    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Выбор автомобиля',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Выберите автомобиль'),
            content: StatefulBuilder(
              builder: (context, setDialogState) {
                var filteredModels = InfinitiModels.models.where((vehicle) {
                  return vehicle.model
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                      vehicle.year
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                      vehicle.engine
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());
                }).toList();

                return AlertDialog(
                  title: const Text('Выберите автомобиль'),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Поиск...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (value) {
                            setDialogState(() {
                              searchQuery = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        Flexible(
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * 0.5,
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredModels.length,
                              itemBuilder: (context, index) {
                                final vehicle = filteredModels[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withOpacity(0.2),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      '${vehicle.model} ${vehicle.year}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Двигатель: ${vehicle.engine}',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                    onTap: () {
                                      _obdController.setVehicle(vehicle);
                                      Navigator.pop(context);
                                      setState(() {
                                        selectedVehicle = vehicle;
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена'),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
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
        title: const Text('OBD Монитор'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildConnectionIndicator(),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildConnectionCard(context),
                  const SizedBox(height: 24),
                  _buildMenuGrid(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isConnected ? 'Подключено' : 'Отключено',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isConnected
                        ? 'OBD адаптер активен'
                        : selectedVehicle == null 
                            ? 'Сначала выберите автомобиль'
                            : 'Нажмите для подключения',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isConnected 
                      ? Colors.green.withOpacity(0.1)
                      : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  isConnected ? Icons.link : Icons.link_off,
                  size: 48,
                  color: isConnected 
                      ? Colors.green
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (!isConnected)
            ElevatedButton(
              onPressed: () async {
                await _showVehicleSelectionDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.directions_car_outlined),
                  const SizedBox(width: 8),
                  const Text('Выбрать автомобиль'),
                ],
              ),
            ),
          if (selectedVehicle != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '${selectedVehicle!.make} ${selectedVehicle!.model} ${selectedVehicle!.year}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: isConnecting || selectedVehicle == null
                ? null
                : (isConnected ? _disconnectFromObd : _connectToObd),
            style: ElevatedButton.styleFrom(
              backgroundColor: isConnected
                  ? Theme.of(context).colorScheme.errorContainer
                  : Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: isConnected
                  ? Theme.of(context).colorScheme.onErrorContainer
                  : Theme.of(context).colorScheme.onPrimaryContainer,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(isConnected ? Icons.link_off : Icons.link),
                const SizedBox(width: 8),
                Text(
                  isConnecting
                      ? 'Подключение...'
                      : (isConnected ? 'Отключить' : 'Подключить'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final menuItems = [
      _buildMenuItem(
        context,
        'Датчики',
        'Показания всех датчиков',
        Icons.sensors_outlined,
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SensorsScreen(
              data: currentData,
              dataStream: _obdController.dataStream,
            ),
          ),
        ),
      ),
      _buildMenuItem(
        context,
        'Ошибки',
        'Чтение и сброс ошибок',
        Icons.warning_outlined,
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ErrorsScreen(data: currentData),
          ),
        ),
      ),
      _buildMenuItem(
        context,
        'Настройки',
        'Настройки приложения',
        Icons.settings_outlined,
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsScreen(),
          ),
        ),
      ),
      _buildMenuItem(
        context,
        'Тюнинг',
        'Настройка параметров и прошивка',
        Icons.settings_outlined,
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TuningScreen(data: currentData),
          ),
        ),
      ),
      _buildMenuItem(
        context,
        'Сырые данные',
        'Просмотр необработанных данных OBD',
        Icons.code,
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RawDataScreen(
              rawDataStream: _obdController.rawDataStream,
            ),
          ),
        ),
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: menuItems,
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: isConnected ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isConnected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
              size: 32,
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isConnected
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.outline,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionIndicator() {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isConnected ? Colors.green : Colors.red,
        boxShadow: [
          BoxShadow(
            color: (isConnected ? Colors.green : Colors.red).withOpacity(0.5),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _obdController.dispose();
    super.dispose();
  }
}
