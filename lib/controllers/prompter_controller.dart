import 'dart:async';
import 'package:flutter/material.dart';
import '../models/prompter_settings.dart';
import '../services/storage_service.dart';

class PrompterController extends ChangeNotifier {
  final ScrollController _scrollController = ScrollController();
  final StorageService _storageService = StorageService();
  
  Timer? _scrollTimer;
  Timer? _countdownTimer;
  bool _isPlaying = false;
  bool _showSpeedControl = false;
  bool _isCountdown = false;
  int _countdownValue = 0;
  PrompterSettings _settings = const PrompterSettings();
  
  // Геттери
  ScrollController get scrollController => _scrollController;
  bool get isPlaying => _isPlaying;
  bool get showSpeedControl => _showSpeedControl;
  bool get isCountdown => _isCountdown;
  int get countdownValue => _countdownValue;
  PrompterSettings get settings => _settings;
  
  // Ініціалізація
  Future<void> initialize() async {
    await _loadSettings();
  }
  
  // Завантаження налаштувань
  Future<void> _loadSettings() async {
    try {
      final speed = await _storageService.loadSpeed();
      final fontSize = await _storageService.loadFontSize();
      final isMirrored = await _storageService.loadMirrorMode();
      final startDelay = await _storageService.loadStartDelay();
      
      _settings = PrompterSettings(
        speed: speed,
        fontSize: fontSize,
        isMirrored: isMirrored,
        startDelay: startDelay,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Помилка завантаження налаштувань: $e');
    }
  }
  
  // Управління відтворенням
  void togglePlayPause() {
    if (_isPlaying || _isCountdown) {
      _stopScrolling();
    } else {
      _startCountdown();
    }
  }
  
  // Countdown перед запуском
  void _startCountdown() {
    if (_settings.startDelay <= 0) {
      _startScrolling();
      return;
    }
    
    _isCountdown = true;
    _countdownValue = _settings.startDelay.ceil();
    notifyListeners();
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _countdownValue--;
      notifyListeners();
      
      if (_countdownValue <= 0) {
        timer.cancel();
        _isCountdown = false;
        _startScrolling();
      }
    });
  }
  
  void _startScrolling() {
    if (_isPlaying) return;
    
    _isPlaying = true;
    notifyListeners();
    
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _scrollToNextPosition();
    });
  }
  
  void _stopScrolling() {
    _isPlaying = false;
    _isCountdown = false;
    notifyListeners();
    _scrollTimer?.cancel();
    _scrollTimer = null;
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }
  
  void _scrollToNextPosition() {
    if (!_isPlaying || !_scrollController.hasClients) return;
    
    final currentPosition = _scrollController.offset;
    // Зменшено крок для максимальної плавності на 60 FPS
    final scrollStep = _settings.speed * 0.5; 
    final newPosition = currentPosition + scrollStep;
    
    if (newPosition >= _scrollController.position.maxScrollExtent) {
      _stopScrolling();
      return;
    }
    
    // Використовуємо jumpTo для найплавнішої прокрутки без анімації
    _scrollController.jumpTo(newPosition);
  }
  
  // Управління налаштуваннями
  void toggleSpeedControl() {
    _showSpeedControl = !_showSpeedControl;
    notifyListeners();
  }
  
  Future<void> updateSpeed(double speed) async {
    _settings = _settings.copyWith(speed: speed);
    notifyListeners();
    
    try {
      await _storageService.saveSpeed(speed);
    } catch (e) {
      debugPrint('Помилка збереження швидкості: $e');
    }
  }
  
  Future<void> updateFontSize(double fontSize) async {
    _settings = _settings.copyWith(fontSize: fontSize);
    notifyListeners();
    
    try {
      await _storageService.saveFontSize(fontSize);
    } catch (e) {
      debugPrint('Помилка збереження розміру шрифту: $e');
    }
  }
  
  Future<void> updateMirrorMode(bool isMirrored) async {
    _settings = _settings.copyWith(isMirrored: isMirrored);
    notifyListeners();
    
    try {
      await _storageService.saveMirrorMode(isMirrored);
    } catch (e) {
      debugPrint('Помилка збереження дзеркального режиму: $e');
    }
  }
  
  Future<void> updateStartDelay(double delay) async {
    _settings = _settings.copyWith(startDelay: delay);
    notifyListeners();
    
    try {
      await _storageService.saveStartDelay(delay);
    } catch (e) {
      debugPrint('Помилка збереження затримки запуску: $e');
    }
  }
  
  @override
  void dispose() {
    _scrollTimer?.cancel();
    _countdownTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
}
