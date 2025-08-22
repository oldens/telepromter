import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _scriptKey = 'script_text';
  static const String _lastModifiedKey = 'last_modified';
  static const String _speedKey = 'scroll_speed';
  static const String _fontSizeKey = 'font_size';
  static const String _isMirroredKey = 'is_mirrored';
  static const String _startDelayKey = 'start_delay';
  
  // Збереження сценарію
  Future<void> saveScript(String text) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_scriptKey, text);
      await prefs.setInt(_lastModifiedKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Простий лог помилки (поки без обробки)
      print('Помилка збереження сценарію: $e');
    }
  }
  
  // Завантаження сценарію
  Future<String?> loadScript() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_scriptKey);
    } catch (e) {
      print('Помилка завантаження сценарію: $e');
      return null;
    }
  }
  
  // Збереження швидкості прокрутки
  Future<void> saveSpeed(double speed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_speedKey, speed);
    } catch (e) {
      print('Помилка збереження швидкості: $e');
    }
  }
  
  // Завантаження швидкості прокрутки
  Future<double> loadSpeed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_speedKey) ?? 1.0; // За замовчуванням 1.0
    } catch (e) {
      print('Помилка завантаження швидкості: $e');
      return 1.0;
    }
  }
  
  // Збереження розміру шрифту
  Future<void> saveFontSize(double fontSize) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_fontSizeKey, fontSize);
    } catch (e) {
      print('Помилка збереження розміру шрифту: $e');
    }
  }
  
  // Завантаження розміру шрифту
  Future<double> loadFontSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_fontSizeKey) ?? 18.0; // За замовчуванням 18.0
    } catch (e) {
      print('Помилка завантаження розміру шрифту: $e');
      return 18.0;
    }
  }
  
  // Збереження дзеркального режиму
  Future<void> saveMirrorMode(bool isMirrored) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isMirroredKey, isMirrored);
    } catch (e) {
      print('Помилка збереження дзеркального режиму: $e');
    }
  }
  
  // Завантаження дзеркального режиму
  Future<bool> loadMirrorMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isMirroredKey) ?? false; // За замовчуванням вимкнено
    } catch (e) {
      print('Помилка завантаження дзеркального режиму: $e');
      return false;
    }
  }
  
  // Збереження затримки запуску
  Future<void> saveStartDelay(double delay) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_startDelayKey, delay);
    } catch (e) {
      print('Помилка збереження затримки запуску: $e');
    }
  }
  
  // Завантаження затримки запуску
  Future<double> loadStartDelay() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_startDelayKey) ?? 2.0; // За замовчуванням 2 секунди
    } catch (e) {
      print('Помилка завантаження затримки запуску: $e');
      return 2.0;
    }
  }
  
  // Перевірка наявності збережених даних
  Future<bool> hasSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_scriptKey);
    } catch (e) {
      return false;
    }
  }
}
