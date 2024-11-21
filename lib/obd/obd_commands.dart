// Класс с командами OBD-II
class ObdCommands {
  static const String rpm = '010C';         // Обороты двигателя
  static const String speed = '010D';       // Скорость
  static const String throttle = '0111';    // Положение дроссельной заслонки
  static const String engineLoad = '0104';  // Нагрузка на двигатель
  static const String coolantTemp = '0105'; // Температура охлаждающей жидкости
  static const String fuelLevel = '012F';   // Уровень топлива
  static const String voltage = 'ATRV';     // Напряжение
} 