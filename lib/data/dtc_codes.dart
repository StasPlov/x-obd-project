class DtcSystem {
  final String name;
  final String code;
  final String description;

  const DtcSystem({
    required this.name,
    required this.code,
    required this.description,
  });
}

class DtcCodes {
  static const Map<String, DtcSystem> systems = {
    'P': DtcSystem(
      name: 'Силовой агрегат',
      code: 'P',
      description: 'Двигатель и трансмиссия',
    ),
    'B': DtcSystem(
      name: 'Кузов',
      code: 'B',
      description: 'Системы кузова',
    ),
    'C': DtcSystem(
      name: 'Шасси',
      code: 'C',
      description: 'Тормоза, подвеска и т.д.',
    ),
    'U': DtcSystem(
      name: 'Сеть',
      code: 'U',
      description: 'Коммуникационные системы',
    ),
  };

  static const Map<String, String> descriptions = {
    'P0100': 'Неисправность датчика массового расхода воздуха',
    'P0101': 'Диапазон/производительность датчика массового расхода воздуха',
    'P0102': 'Низкий вход датчика массового расхода воздуха',
    // Добавьте больше кодов ошибок
  };

  static String getDescription(String code) {
    return descriptions[code] ?? 'Неизвестная ошибка';
  }

  static String getSeverity(String code) {
    if (code.startsWith('P0')) return 'Критическая';
    if (code.startsWith('P1')) return 'Производитель';
    return 'Средняя';
  }
} 