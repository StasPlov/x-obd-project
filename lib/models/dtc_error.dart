class DtcError {
  final String code;
  final String description;
  final String severity;
  final String system;
  final bool isPending;

  DtcError({
    required this.code,
    required this.description,
    required this.severity,
    required this.system,
    this.isPending = false,
  });
} 