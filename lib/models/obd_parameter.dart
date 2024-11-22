class ObdParameter {
  final String key;          // Ключ параметра (rpm, speed и т.д.)
  final String pid;          // PID код для OBD (010C, 010D и т.д.)
  final String name;         // Название для отображения
  final String unit;         // Единица измерения
  final String category;     // Категория (двигатель, движение и т.д.)
  final Function parser;     // Функция для парсинга ответа

  const ObdParameter({
    required this.key,
    required this.pid,
    required this.name,
    required this.unit,
    required this.category,
    required this.parser,
  });
} 