import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _scriptKey = 'script_text';
  static const String _lastModifiedKey = 'last_modified';
  
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
