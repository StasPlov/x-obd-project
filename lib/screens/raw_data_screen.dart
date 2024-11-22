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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _subscribeToData();
  }

  void _subscribeToData() {
    widget.rawDataStream.listen((data) {
      setState(() {
        _rawDataLines.insert(0, '${DateTime.now().toString().substring(11, 23)} > $data');
        if (_rawDataLines.length > 100) {
          _rawDataLines.removeLast();
        }
      });
    });
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
              setState(() {
                _rawDataLines.clear();
              });
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
} 