class ObdDataGroup {
  final String title;
  final String icon;
  final List<ObdDataItem> items;

  ObdDataGroup({
    required this.title,
    required this.icon,
    required this.items,
  });
}

class ObdDataItem {
  final String title;
  final String value;
  final String unit;
  final String icon;
  final String? description;

  ObdDataItem({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    this.description,
  });
} 