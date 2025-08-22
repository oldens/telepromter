import 'dart:async';
import 'package:flutter/material.dart';
import '../models/prompter_settings.dart';
import '../services/storage_service.dart';

class PrompterController extends ChangeNotifier {
  final ScrollController _scrollController = ScrollController();
  final StorageService _storageService = StorageService();
  
  Timer? _scrollTimer;
  bool _isPlaying = false;
  bool _showSpeedControl = false;
  PrompterSettings _settings = const PrompterSettings();
  
  // Геттери
  ScrollController get scrollController => _scrollController;
  bool get isPlaying => _isPlaying;
  bool get showSpeedControl => _showSpeedControl;
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
      
      _settings = PrompterSettings(
        speed: speed,
        fontSize: fontSize,
        isMirrored: isMirrored,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Помилка завантаження налаштувань: $e');
    }
  }
  
  // Управління відтворенням
  void togglePlayPause() {
    if (_isPlaying) {
      _stopScrolling();
    } else {
      _startScrolling();
    }
  }
  
  void _startScrolling() {
    if (_isPlaying) return;
    
    _isPlaying = true;
    notifyListeners();
    
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _scrollToNextPosition();
    });
  }
  
  void _stopScrolling() {
    _isPlaying = false;
    notifyListeners();
    _scrollTimer?.cancel();
    _scrollTimer = null;
  }
  
  void _scrollToNextPosition() {
    if (!_isPlaying || !_scrollController.hasClients) return;
    
    final currentPosition = _scrollController.offset;
    final scrollStep = _settings.speed * 0.3;
    final newPosition = currentPosition + scrollStep;
    
    if (newPosition >= _scrollController.position.maxScrollExtent) {
      _stopScrolling();
      return;
    }
    
    _scrollController.animateTo(
      newPosition,
      duration: Duration(milliseconds: (200 / _settings.speed).round()),
      curve: Curves.easeOut,
    );
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
  
  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
}
