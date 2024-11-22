// Класс с командами OBD-II
class ObdCommands {
  static const String readDtc = '03';      // Чтение ошибок DTC
  static const String readPendingDtc = '07'; // Чтение отложенных ошибок
  static const String clearDtc = '04';     // Сброс ошибок
} 