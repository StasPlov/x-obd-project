import 'dart:async';

import 'package:flutter/material.dart';

class RawDataScreen extends StatefulWidget {
  final Stream<String> rawDataStream;

  const RawDataScreen({
    super.key,
    required this.rawDataStream,
  });

  @override
  State<RawDataScreen> createState() => _RawDataScreenState();
}

class _RawDataScreenState extends State<RawDataScreen> {
  final List<String> _rawDataLines = [];
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscribeToData();
  }

  void _subscribeToData() {
    _subscription = widget.rawDataStream.listen(
      (data) {
        if (mounted) {
          setState(() {
            _rawDataLines.add(data);
            if (_rawDataLines.length > 100) {
              _rawDataLines.removeAt(0);
            }
          });
        }
      },
      onError: (error) {
        print('Ошибка получения данных: $error');
      },
      cancelOnError: false,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
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
        title: const Text('Сырые данные OBD'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              if (mounted) {
                setState(() {
                  _rawDataLines.clear();
                });
              }
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Последние полученные данные:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      _rawDataLines.join('\n'),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 