class Vehicle {
  final String make;
  final String model;
  final String year;
  final String engine;
  final Map<String, String> supportedPids;

  Vehicle({
    required this.make,
    required this.model,
    required this.year,
    required this.engine,
    required this.supportedPids,
  });
} 