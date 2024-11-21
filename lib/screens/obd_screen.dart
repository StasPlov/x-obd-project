import 'package:flutter/material.dart';
import '../obd/wifi_obd_controller.dart'; // Предполагаемый путь к контроллеру

class ObdScreen extends StatefulWidget {
	@override
	_ObdScreenState createState() => _ObdScreenState();
}

class _ObdScreenState extends State<ObdScreen> {
	final WifiObdController _obdController = WifiObdController();
	bool isConnected = false;
	bool isConnecting = false;
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
					SnackBar(
						content: Text('Успешно подключено к OBD'),
						backgroundColor: Colors.green,
					),
				);
			});
		} catch (e) {
			ScaffoldMessenger.of(context).showSnackBar(
				SnackBar(
					content: Text('Ошибка подключения: $e'),
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
			SnackBar(
				content: Text('Отключено от OBD'),
				backgroundColor: Colors.orange,
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('OBD Монитор'),
				actions: [
					Padding(
						padding: EdgeInsets.all(8.0),
						child: Center(
							child: Container(
								width: 12,
								height: 12,
								decoration: BoxDecoration(
									shape: BoxShape.circle,
									color: isConnected ? Colors.green : Colors.red,
								),
							),
						),
					),
				],
			),
			body: Column(
				children: [
					Container(
						padding: EdgeInsets.all(16),
						color: Colors.grey[200],
						child: Row(
							children: [
								Expanded(
									child: Text(
										isConnected 
											? 'Подключено к OBD'
											: 'Не подключено',
										style: TextStyle(
											fontSize: 16,
											fontWeight: FontWeight.bold,
										),
									),
								),
								ElevatedButton.icon(
									onPressed: isConnecting 
										? null 
										: (isConnected ? _disconnectFromObd : _connectToObd),
									icon: Icon(
										isConnected ? Icons.link_off : Icons.link,
									),
									label: Text(
										isConnecting
											? 'Подключение...'
											: (isConnected ? 'Отключить' : 'Подключить'),
									),
									style: ElevatedButton.styleFrom(
										backgroundColor: isConnected ? Colors.red : Colors.blue,
									),
								),
							],
						),
					),
					
					Expanded(
						child: isConnected ? ListView(
							padding: EdgeInsets.all(16),
							children: [
								_buildDataCard(
									'Обороты двигателя',
									'${currentData['rpm']?.toString() ?? "---"} RPM',
									Icons.speed,
								),
								_buildDataCard(
									'Скорость',
									'${currentData['speed']?.toString() ?? "---"} км/ч',
									Icons.directions_car,
								),
								_buildDataCard(
									'Дроссель',
									'${currentData['throttle']?.toStringAsFixed(1) ?? "---"}%',
									Icons.timeline,
								),
								_buildDataCard(
									'Температура ОЖ',
									'${currentData['temp']?.toString() ?? "---"}°C',
									Icons.thermostat,
								),
							],
						) : Center(
							child: Column(
								mainAxisAlignment: MainAxisAlignment.center,
								children: [
									Icon(
										Icons.car_repair,
										size: 64,
										color: Colors.grey,
									),
									SizedBox(height: 16),
									Text(
										'Подключитесь к OBD для просмотра данных',
										style: TextStyle(
											fontSize: 16,
											color: Colors.grey,
										),
									),
								],
							),
						),
					),
				],
			),
		);
	}

	Widget _buildDataCard(String title, String value, IconData icon) {
		return Card(
			margin: EdgeInsets.only(bottom: 8),
			elevation: 2,
			child: Padding(
				padding: EdgeInsets.all(16),
				child: Row(
					children: [
						Container(
							padding: EdgeInsets.all(8),
							decoration: BoxDecoration(
								color: Colors.blue[50],
								borderRadius: BorderRadius.circular(8),
							),
							child: Icon(icon, size: 32, color: Colors.blue),
						),
						SizedBox(width: 16),
						Expanded(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										title,
										style: TextStyle(
											fontSize: 14,
											color: Colors.grey[600],
										),
									),
									SizedBox(height: 4),
									Text(
										value,
										style: TextStyle(
											fontSize: 24,
											fontWeight: FontWeight.bold,
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

	@override
	void dispose() {
		_obdController.dispose();
		super.dispose();
	}
}
