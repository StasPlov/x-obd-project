class TuningConfig {
  final String id;
  final String name;
  final DateTime createdAt;
  final Map<String, dynamic> parameters;
  final String description;

  TuningConfig({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.parameters,
    required this.description,
  });
}

class TuningParameter {
  final String name;
  final double value;
  final String unit;
  final double minValue;
  final double maxValue;
  final String description;

  TuningParameter({
    required this.name,
    required this.value,
    required this.unit,
    required this.minValue,
    required this.maxValue,
    required this.description,
  });
} 