import 'package:flutter/material.dart';
import '../obd/wifi_obd_controller.dart'; // Предполагаемый путь к контроллеру
import 'errors_screen.dart';
import 'sensors_screen.dart';
import 'settings_screen.dart';
import 'tuning_screen.dart';

class MainScreen extends StatefulWidget {
	const MainScreen({super.key});

	@override
	_MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
	final WifiObdController _obdController = WifiObdController();
	bool isConnected = true;
	bool isConnecting = true;
	Map<String, dynamic> currentData = {};

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
					content: Text("Ошибка подключения: $e"),
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
										isConnected ? 'OBD адаптер активен' : 'Нажмите для подключения',
										style: TextStyle(
											fontSize: 14,
											color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
										),
									),
								],
							),
							Icon(
								isConnected ? Icons.link : Icons.link_off,
								size: 48,
								color: Theme.of(context).colorScheme.primary,
							),
						],
					),
					const SizedBox(height: 20),
					ElevatedButton(
						onPressed: isConnecting 
							? null 
							: (isConnected ? _disconnectFromObd : _connectToObd),
						style: ElevatedButton.styleFrom(
							backgroundColor: isConnected 
								? Theme.of(context).colorScheme.errorContainer
								: Theme.of(context).colorScheme.primaryContainer,
							minimumSize: const Size(double.infinity, 45),
							shape: RoundedRectangleBorder(
								borderRadius: BorderRadius.circular(12),
							),
						),
						child: Text(
							isConnecting
								? 'Подключение...'
								: (isConnected ? 'Отключить' : 'Подключить'),
							style: TextStyle(
								color: isConnected 
									? Theme.of(context).colorScheme.onErrorContainer
									: Theme.of(context).colorScheme.onPrimaryContainer,
							),
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
						builder: (context) => SensorsScreen(data: currentData),
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
					borderRadius: BorderRadius.circular(16)
				),
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
