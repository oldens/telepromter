# ТЕХНІЧНА СПЕЦИФІКАЦІЯ
**Simple Prompter (Простий Суфлер)**

---

## 📋 Загальна інформація

**Назва проекту**: Простий Суфлер (Simple Prompter)  
**Версія**: 1.0.0 Production Ready  
**Мова розробки**: Dart/Flutter 3.32.7  
**Цільові платформи**: Android ✅, iOS ✅, Web ✅, macOS ✅  
**GitHub**: https://github.com/oldens/telepromter  
**Production APK**: app-release.apk (21.2MB)

---

## 🏛️ Архітектура проекту

### MVC (Model-View-Controller) структура

```
telepromter/
├── android/                           # Android підтримка ✅
├── ios/                               # iOS підтримка ✅ (Runner.xcodeproj)
├── lib/                               # Основний код Dart (MVC)
│   ├── main.dart                      # Точка входу
│   ├── models/                        # MODEL - Дані
│   │   └── prompter_settings.dart     # Налаштування (44 рядки)
│   ├── controllers/                   # CONTROLLER - Логіка
│   │   └── prompter_controller.dart   # 60 FPS контролер (179 рядків)
│   ├── screens/                       # VIEW - UI екрани
│   │   ├── home_screen.dart           # Редагування (163 рядки)
│   │   └── prompter_screen.dart       # Суфлер (155 рядків)
│   ├── widgets/                       # Компоненти UI
│   │   └── prompter_control_panel.dart # Панель налаштувань
│   └── services/                      # Сервіси
│       └── storage_service.dart       # SharedPreferences
└── build/app/outputs/flutter-apk/    # Production збірка
    └── app-release.apk               # 21.2MB готовий APK
```

---

## 🔧 Технічний стек

### Основні технології
- **Flutter 3.32.7** - Кроссплатформний фреймворк
- **Dart 3.8.1** - Мова програмування
- **Material Design 3** - Дизайн система

### Архітектурні рішення
- **MVC Pattern** - чіткий розділ відповідальностей
- **ChangeNotifier** - реактивне управління станом
- **SharedPreferences** - локальне збереження даних
- **Timer API** - прецизійна 60 FPS прокрутка

---

## ⚙️ Ключові компоненти

### 1. PrompterController (CONTROLLER)
- **60 FPS логіка** - Timer(16ms) для плавності
- **Управління станом** - стоп/плей/пауза
- **Countdown функція** - затримка запуску
- **Налаштування** - швидкість, шрифт, дзеркало

### 2. PrompterSettings (MODEL)
```dart
class PrompterSettings {
  final double speed;        // 0.5x - 10.0x
  final double fontSize;     // 14px - 64px
  final bool isMirrored;     // дзеркальний режим
  final double startDelay;   // 0s - 10s затримка
}
```

### 3. PrompterScreen (VIEW)
- **Головний екран суфлера** (НЕ _refactored версія)
- **60 FPS прокрутка** з jumpTo() для плавності
- **Тап по тексту** - інтуїтивне керування
- **Countdown відображення** - візуальний відлік

### 4. PrompterControlPanel (WIDGET)
- **Адаптивна панель** - landscape/portrait режими
- **Слайдери налаштувань** - швидкість, шрифт, затримка
- **Прокручувана** - для малих екранів

---

## 📱 Платформна специфіка

### Android
- **API Level**: 21+ (Android 5.0+)
- **NDK Version**: 27.0.12077973
- **Готовий APK**: 21.2MB
- **Тестування**: Емулятор + реальні пристрої

### iOS
- **iOS Version**: 18.3+
- **Xcode проект**: Runner.xcodeproj
- **Тестування**: iPhone 16 Pro Simulator
- **UUID емулятора**: 23B4A541-FFAE-439F-9354-6B89B752FA54

### Web
- **Браузери**: Chrome, Safari, Firefox
- **Тестування**: Chrome (пріоритет)
- **Запуск**: `flutter run -d chrome`

---

## 🚀 Розгортання та збірка

### Команди збірки
```bash
# Android APK
flutter build apk --release

# iOS (потребує macOS + Xcode)
flutter build ios --release

# Web
flutter build web --release
```

### Тестування
```bash
# Швидке тестування
flutter run -d chrome

# iOS Simulator
flutter run -d 23B4A541-FFAE-439F-9354-6B89B752FA54

# Android
flutter run -d <device-id>
```

---

## 🔍 Ключові алгоритми

### 60 FPS Прокрутка
- **Timer частота**: 16ms (60 FPS)
- **Метод**: `jumpTo()` замість `animateTo()`
- **Крок прокрутки**: `speed * 0.5px`
- **Плавність**: Мікро-кроки без анімації

### Landscape адаптація
- **Адаптивне позиціонування**: 10px vs 80px відступ
- **Компактний дизайн**: менші відступи та шрифти
- **Прокручувана панель**: для доступу до всіх контролів

---

## 📊 Метрики продуктивності

- **Запуск додатку**: < 2 секунди
- **60 FPS прокрутка**: Стабільно досягнуто
- **Розмір APK**: 21.2MB (tree-shaking оптимізація)
- **Час відгуку UI**: < 16ms
- **Пам'ять**: Оптимізовано для мобільних пристроїв

---

## 🔒 Безпека та приватність

- **100% локальні дані** - жодної мережевої активності
- **SharedPreferences** - захищене локальне збереження
- **Мінімальні дозволи** - тільки необхідні системні права
- **Повна анонімність** - відсутність tracking

---

**Документ оновлено: Грудень 2024**  
**Версія: 1.0.0 Production Ready**