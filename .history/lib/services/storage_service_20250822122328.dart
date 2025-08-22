import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _scriptKey = 'script_text';
  static const String _lastModifiedKey = 'last_modified';
  static const String _speedKey = 'scroll_speed';
  
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
