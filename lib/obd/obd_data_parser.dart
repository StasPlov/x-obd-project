// Класс для парсинга ответов OBD
class ObdDataParser {
  static int? parseRPM(String response) {
    try {
      if (response.startsWith('41 0C')) {
        var bytes = response.substring(6).trim().split(' ');
        if (bytes.length >= 2) {
          int a = int.parse(bytes[0], radix: 16);
          int b = int.parse(bytes[1], radix: 16);
          return ((a * 256) + b) ~/ 4;
        }
      }
    } catch (e) {
      print('Ошибка парсинга RPM: $e');
    }
    return null;
  }

  static int? parseSpeed(String response) {
    try {
      if (response.startsWith('41 0D')) {
        var byte = response.substring(6).trim();
        return int.parse(byte, radix: 16);
      }
    } catch (e) {
      print('Ошибка парсинга Speed: $e');
    }
    return null;
  }

  static double? parseThrottle(String response) {
    try {
      if (response.startsWith('41 11')) {
        var byte = response.substring(6).trim();
        return (int.parse(byte, radix: 16) * 100) / 255;
      }
    } catch (e) {
      print('Ошибка парсинга Throttle: $e');
    }
    return null;
  }

  static int? parseTemp(String response) {
    try {
      if (response.startsWith('41 05')) {
        var byte = response.substring(6).trim();
        return int.parse(byte, radix: 16) - 40;
      }
    } catch (e) {
      print('Ошибка парсинга Temperature: $e');
    }
    return null;
  }

  static double? parseEngineLoad(String response) {
    try {
      if (response.startsWith('41 04')) {
        var byte = response.substring(6).trim();
        return (int.parse(byte, radix: 16) * 100) / 255;
      }
    } catch (e) {
      print('Ошибка парсинга Engine Load: $e');
    }
    return null;
  }

  static double? parseFuelLevel(String response) {
    try {
      if (response.startsWith('41 2F')) {
        var byte = response.substring(6).trim();
        return (int.parse(byte, radix: 16) * 100) / 255;
      }
    } catch (e) {
      print('Ошибка парсинга Fuel Level: $e');
    }
    return null;
  }

  static double? parseVoltage(String response) {
    try {
      if (response.startsWith('ATRV')) {
        var voltage = response.substring(4).trim();
        return double.parse(voltage);
      }
    } catch (e) {
      print('Ошибка парсинга Voltage: $e');
    }
    return null;
  }
} 