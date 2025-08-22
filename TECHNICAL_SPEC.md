# Технічна специфікація: "Простий Суфлер"

## 📋 Загальна інформація

**Назва проекту**: Простий Суфлер (Simple Prompter)  
**Версія**: 1.0.0 (MVP)  
**Дата створення**: Грудень 2024  
**Мова розробки**: Dart/Flutter  
**Цільова платформа**: Android, iOS, Web  

---

## 🆕 НОВІ ФУНКЦІЇ (Post-MVP)

### 1. Інтерактивне керування
- **Клік по тексту** - стоп/плей (альтернатива кнопці)
- **Жести прокрутки** - мануальне прокручування при паузі
- **Затримка запуску** - 2 секунди перед початком з візуальним індикатором

### 2. Розширені налаштування
- **Налаштування затримки** - 0-10 секунд з кроком 0.5s
- **Візуальний зворотний зв'язок** - countdown таймер
- **Збереження затримки** - в SharedPreferences

---

## 🏗️ Архітектура проекту

### 1. Загальна структура
```
telepromter/
├── android/                 # Android специфічні файли
├── ios/                     # iOS специфічні файли
├── web/                     # Web специфічні файли
├── lib/                     # Основний код Dart
│   ├── main.dart           # Точка входу
│   ├── app.dart            # Головний додаток
│   ├── screens/            # Екрани
│   ├── widgets/            # Перевикористовувані віджети
│   ├── models/             # Моделі даних
│   ├── services/           # Бізнес-логіка
│   ├── utils/              # Утиліти
│   └── constants/          # Константи
├── assets/                  # Ресурси (шрифти, зображення)
├── test/                    # Тести
├── pubspec.yaml            # Залежності
└── README.md               # Документація
```

### 2. Патерни архітектури
- **MVVM (Model-View-ViewModel)** для екранів
- **Service Layer** для бізнес-логіки
- **Repository Pattern** для роботи з даними
- **Observer Pattern** для реактивності

---

## 🎨 Дизайн система

### 1. Кольорова палітра
```dart
class AppColors {
  // Основні кольори
  static const Color primary = Color(0xFF2196F3);      // Синій
  static const Color secondary = Color(0xFF03DAC6);    // Бірюзовий
  static const Color background = Color(0xFF121212);   // Темно-сірий
  static const Color surface = Color(0xFF1E1E1E);      // Сірий
  
  // Текст
  static const Color onPrimary = Color(0xFFFFFFFF);    // Білий
  static const Color onSecondary = Color(0xFF000000);  // Чорний
  static const Color onBackground = Color(0xFFFFFFFF); // Білий
  static const Color onSurface = Color(0xFFFFFFFF);    // Білий
  
  // Стани
  static const Color error = Color(0xFFCF6679);        // Червоний
  static const Color success = Color(0xFF4CAF50);      // Зелений
  static const Color warning = Color(0xFFFF9800);      // Помаранчевий
}
```

### 2. Типографіка
```dart
class AppTypography {
  // Заголовки
  static const TextStyle h1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
  );
  
  // Текст
  static const TextStyle body1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.15,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
  );
  
  // Кнопки
  static const TextStyle button = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
  );
}
```

### 3. Відступи та розміри
```dart
class AppSpacing {
  // Базові відступи
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  
  // Радіуси
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
}
```

---

## 📱 Екрани та навігація

### 1. Структура навігації
```
App
├── HomeScreen (початковий екран)
│   ├── TextEditor
│   ├── StartButton
│   └── SettingsButton
└── PrompterScreen
    ├── ScriptDisplay
    ├── ControlPanel
    └── NavigationBar
```

### 2. Детальний опис екранів

#### HomeScreen
**Призначення**: Редагування та управління сценарієм  
**Ключові компоненти**:
- `TextEditingController` для управління текстом
- `AutoSaveService` для автоматичного збереження
- `ValidationService` для перевірки тексту

**UI елементи**:
```dart
Scaffold(
  appBar: AppBar(
    title: Text('Простий Суфлер'),
    actions: [
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () => _showSettings(),
      ),
    ],
  ),
  body: Column(
    children: [
      Expanded(
        child: TextField(
          controller: _textController,
          maxLines: null,
          expands: true,
          decoration: InputDecoration(
            hintText: 'Введіть ваш сценарій тут...',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _textController.text.isNotEmpty ? _startPrompter : null,
                icon: Icon(Icons.play_arrow),
                label: Text('Старт'),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
)
```

#### PrompterScreen
**Призначення**: Відображення та прокрутка сценарію  
**Ключові компоненти**:
- `ScrollController` для управління прокруткою
- `TimerService` для автоматичної прокрутки
- `ControlPanel` для налаштувань

**UI елементи**:
```dart
Scaffold(
  backgroundColor: AppColors.background,
  body: GestureDetector(
    onTap: _togglePlayPause,
    onDoubleTap: _toggleControls,
    child: Stack(
      children: [
        // Основний текст
        SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Text(
              widget.scriptText,
              style: AppTypography.body1.copyWith(
                color: AppColors.onBackground,
                fontSize: _fontSize,
              ),
            ),
          ),
        ),
        
        // Панель керування
        if (_showControls)
          Positioned(
            bottom: AppSpacing.lg,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            child: ControlPanel(
              speed: _speed,
              fontSize: _fontSize,
              isMirrored: _isMirrored,
              onSpeedChanged: _onSpeedChanged,
              onFontSizeChanged: _onFontSizeChanged,
              onMirrorChanged: _onMirrorChanged,
            ),
          ),
      ],
    ),
  ),
)
```

---

## 🔧 Сервіси та логіка

### 1. StorageService
**Призначення**: Управління локальним збереженням даних  
**Залежності**: `shared_preferences`  
**Ключові методи**:

```dart
class StorageService {
  static const String _scriptKey = 'script_text';
  static const String _lastModifiedKey = 'last_modified';
  static const String _speedKey = 'scroll_speed';
  static const String _fontSizeKey = 'font_size';
  static const String _mirrorKey = 'mirror_mode';
  
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
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setDouble(_speedKey, speed),
        prefs.setDouble(_fontSizeKey, fontSize),
        prefs.setBool(_mirrorKey, isMirrored),
      ]);
    } catch (e) {
      throw StorageException('Помилка збереження налаштувань: $e');
    }
  }
}
```

### 2. TimerService
**Призначення**: Управління автоматичною прокруткою  
**Залежності**: `dart:async`  
**Ключові методи**:

```dart
class TimerService {
  Timer? _timer;
  bool _isPlaying = false;
  double _speed = 1.0;
  final ScrollController _scrollController;
  
  TimerService(this._scrollController);
  
  // Запуск прокрутки
  void startScrolling() {
    if (_isPlaying) return;
    
    _isPlaying = true;
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (!_isPlaying) {
        timer.cancel();
        return;
      }
      
      _scrollToNextPosition();
    });
  }
  
  // Зупинка прокрутки
  void stopScrolling() {
    _isPlaying = false;
    _timer?.cancel();
    _timer = null;
  }
  
  // Прокрутка до наступної позиції
  void _scrollToNextPosition() {
    if (!_scrollController.hasClients) return;
    
    final currentOffset = _scrollController.offset;
    final maxOffset = _scrollController.position.maxScrollExtent;
    final newOffset = currentOffset + (_speed * 0.05);
    
    if (newOffset <= maxOffset) {
      _scrollController.animateTo(
        newOffset,
        duration: Duration(milliseconds: 50),
        curve: Curves.linear,
      );
    } else {
      stopScrolling();
    }
  }
  
  // Встановлення швидкості
  void setSpeed(double speed) {
    _speed = speed.clamp(0.5, 3.0);
  }
  
  // Очищення ресурсів
  void dispose() {
    stopScrolling();
  }
}
```

### 3. ValidationService
**Призначення**: Валідація введеного тексту  
**Ключові методи**:

```dart
class ValidationService {
  // Перевірка довжини тексту
  static bool isValidLength(String text) {
    return text.trim().length >= 10;
  }
  
  // Перевірка наявності недопустимих символів
  static bool hasInvalidCharacters(String text) {
    final invalidChars = RegExp(r'[<>{}]');
    return invalidChars.hasMatch(text);
  }
  
  // Повна валідація
  static ValidationResult validateScript(String text) {
    if (text.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Сценарій не може бути порожнім',
      );
    }
    
    if (!isValidLength(text)) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Сценарій має бути не менше 10 символів',
      );
    }
    
    if (hasInvalidCharacters(text)) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Сценарій містить недопустимі символи',
      );
    }
    
    return ValidationResult(isValid: true);
  }
}

class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  
  ValidationResult({required this.isValid, this.errorMessage});
}
```

---

## 📊 Моделі даних

### 1. ScriptModel
```dart
class ScriptModel {
  final String id;
  final String text;
  final DateTime createdAt;
  final DateTime lastModified;
  final int wordCount;
  final int characterCount;
  
  ScriptModel({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.lastModified,
  }) : wordCount = text.split(' ').length,
       characterCount = text.length;
  
  // Створення з JSON
  factory ScriptModel.fromJson(Map<String, dynamic> json) {
    return ScriptModel(
      id: json['id'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
    );
  }
  
  // Конвертація в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
    };
  }
  
  // Копіювання з змінами
  ScriptModel copyWith({
    String? text,
    DateTime? lastModified,
  }) {
    return ScriptModel(
      id: id,
      text: text ?? this.text,
      createdAt: createdAt,
      lastModified: lastModified ?? DateTime.now(),
    );
  }
}
```

### 2. PrompterSettings
```dart
class PrompterSettings {
  final double scrollSpeed;
  final double fontSize;
  final bool isMirrored;
  final bool autoSave;
  final Duration autoSaveDelay;
  
  PrompterSettings({
    this.scrollSpeed = 1.0,
    this.fontSize = 18.0,
    this.isMirrored = false,
    this.autoSave = true,
    this.autoSaveDelay = const Duration(milliseconds: 500),
  });
  
  // Завантаження з SharedPreferences
  static Future<PrompterSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return PrompterSettings(
      scrollSpeed: prefs.getDouble('scroll_speed') ?? 1.0,
      fontSize: prefs.getDouble('font_size') ?? 18.0,
      isMirrored: prefs.getBool('is_mirrored') ?? false,
      autoSave: prefs.getBool('auto_save') ?? true,
      autoSaveDelay: Duration(
        milliseconds: prefs.getInt('auto_save_delay') ?? 500,
      ),
    );
  }
  
  // Збереження в SharedPreferences
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setDouble('scroll_speed', scrollSpeed),
      prefs.setDouble('font_size', fontSize),
      prefs.setBool('is_mirrored', isMirrored),
      prefs.setBool('auto_save', autoSave),
      prefs.setInt('auto_save_delay', autoSaveDelay.inMilliseconds),
    ]);
  }
}
```

---

## 🧪 Тестування

### 1. Unit тести
```dart
// test/services/storage_service_test.dart
void main() {
  group('StorageService Tests', () {
    late StorageService storageService;
    
    setUp(() {
      storageService = StorageService();
    });
    
    test('should save and load script correctly', () async {
      const testText = 'Test script text';
      
      await storageService.saveScript(testText);
      final loadedText = await storageService.loadScript();
      
      expect(loadedText, equals(testText));
    });
  });
}
```

### 2. Widget тести
```dart
// test/screens/home_screen_test.dart
void main() {
  testWidgets('HomeScreen should display text field and start button', (tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));
    
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Старт'), findsOneWidget);
  });
}
```

### 3. Інтеграційні тести
```dart
// integration_test/app_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Complete user flow test', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    
    // Введення тексту
    await tester.enterText(find.byType(TextField), 'Test script');
    await tester.pumpAndSettle();
    
    // Натискання кнопки старт
    await tester.tap(find.text('Старт'));
    await tester.pumpAndSettle();
    
    // Перевірка переходу на екран суфлера
    expect(find.byType(PrompterScreen), findsOneWidget);
  });
}
```

---

## 🚀 Оптимізація та продуктивність

### 1. Оптимізація пам'яті
- Використання `const` конструкторів
- Правильне управління життєвим циклом віджетів
- Очищення ресурсів в `dispose()`

### 2. Оптимізація продуктивності
- Використання `ListView.builder` для великих текстів
- Дебаунс для автозбереження
- Оптимізація анімацій прокрутки

### 3. Моніторинг продуктивності
```dart
class PerformanceMonitor {
  static void measureOperation(String operationName, Function operation) {
    final stopwatch = Stopwatch()..start();
    operation();
    stopwatch.stop();
    
    debugPrint('$operationName took ${stopwatch.elapsedMilliseconds}ms');
  }
}
```

---

## 📱 Підтримка платформ

### 1. Android
- Мінімальна версія: API 21 (Android 5.0)
- Цільова версія: API 34 (Android 14)
- Підтримка різних розмірів екрану
- Адаптивний дизайн для планшетів

### 2. iOS
- Мінімальна версія: iOS 11.0
- Цільова версія: iOS 17.0
- Підтримка iPhone та iPad
- Адаптація під різні розміри екрану

### 3. Web
- Підтримка сучасних браузерів
- Responsive дизайн
- PWA функціональність
- Клавіатурне керування

---

## 🔒 Безпека та приватність

### 1. Локальне збереження
- Всі дані зберігаються локально на пристрої
- Немає передачі даних на зовнішні сервери
- Шифрування не потрібне (локальні дані)

### 2. Дозволи
- Android: `WRITE_EXTERNAL_STORAGE` (для експорту)
- iOS: `NSDocumentsFolderUsageDescription`
- Web: `navigator.storage` API

---

## 📈 Метрики та аналітика

### 1. Внутрішні метрики
- Час запуску додатку
- Використання пам'яті
- FPS при прокрутці
- Кількість збережених сценаріїв

### 2. Користувацькі метрики
- Час використання суфлера
- Частота зміни налаштувань
- Популярні розміри шрифту
- Використання дзеркального режиму

---

**Версія документа**: 1.0  
**Останнє оновлення**: Грудень 2024  
**Статус**: Готово до реалізації
