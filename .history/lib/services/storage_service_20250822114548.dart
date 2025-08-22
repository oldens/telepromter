import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _scriptKey = 'script_text';
  static const String _lastModifiedKey = 'last_modified';
  static const String _speedKey = 'scroll_speed';
  static const String _fontSizeKey = 'font_size';
  static const String _mirrorKey = 'mirror_mode';
  static const String _autoSaveKey = 'auto_save';
  static const String _autoSaveDelayKey = 'auto_save_delay';
  
  // Збереження сценарію
  Future<void> saveScript(String text) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_scriptKey, text);
      await prefs.setInt(_lastModifiedKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw StorageException('Помилка збереження сценарію: $e');
    }
  }
  
  // Завантаження сценарію
  Future<String?> loadScript() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_scriptKey);
    } catch (e) {
      throw StorageException('Помилка завантаження сценарію: $e');
    }
  }
  
  // Збереження налаштувань
  Future<void> saveSettings({
    required double speed,
    required double fontSize,
    required bool isMirrored,
    required bool autoSave,
    required int autoSaveDelay,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setDouble(_speedKey, speed),
        prefs.setDouble(_fontSizeKey, fontSize),
        prefs.setBool(_mirrorKey, isMirrored),
        prefs.setBool(_autoSaveKey, autoSave),
        prefs.setInt(_autoSaveDelayKey, autoSaveDelay),
      ]);
    } catch (e) {
      throw StorageException('Помилка збереження налаштувань: $e');
    }
  }
  
  // Завантаження налаштувань
  Future<Map<String, dynamic>> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'speed': prefs.getDouble(_speedKey) ?? 1.0,
        'fontSize': prefs.getDouble(_fontSizeKey) ?? 18.0,
        'isMirrored': prefs.getBool(_mirrorKey) ?? false,
        'autoSave': prefs.getBool(_autoSaveKey) ?? true,
        'autoSaveDelay': prefs.getInt(_autoSaveDelayKey) ?? 500,
      };
    } catch (e) {
      throw StorageException('Помилка завантаження налаштувань: $e');
    }
  }
  
  // Очищення всіх даних
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      throw StorageException('Помилка очищення даних: $e');
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

class StorageException implements Exception {
  final String message;
  
  StorageException(this.message);
  
  @override
  String toString() => 'StorageException: $message';
}
