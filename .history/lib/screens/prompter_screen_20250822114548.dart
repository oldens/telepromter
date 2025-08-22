import 'package:flutter/material.dart';
import 'package:simple_prompter/constants/app_colors.dart';
import 'package:simple_prompter/constants/app_spacing.dart';
import 'package:simple_prompter/constants/app_typography.dart';
import 'package:simple_prompter/services/storage_service.dart';
import 'package:simple_prompter/widgets/control_panel.dart';

class PrompterScreen extends StatefulWidget {
  final String scriptText;
  
  const PrompterScreen({
    super.key,
    required this.scriptText,
  });

  @override
  State<PrompterScreen> createState() => _PrompterScreenState();
}

class _PrompterScreenState extends State<PrompterScreen> {
  final ScrollController _scrollController = ScrollController();
  final StorageService _storageService = StorageService();
  
  bool _isPlaying = false;
  bool _showControls = false;
  double _speed = 1.0;
  double _fontSize = 18.0;
  bool _isMirrored = false;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  // Завантаження налаштувань
  Future<void> _loadSettings() async {
    try {
      final settings = await _storageService.loadSettings();
      setState(() {
        _speed = settings['speed'] as double;
        _fontSize = settings['fontSize'] as double;
        _isMirrored = settings['isMirrored'] as bool;
      });
    } catch (e) {
      // Використовуємо значення за замовчуванням
    }
  }
  
  // Збереження налаштувань
  Future<void> _saveSettings() async {
    try {
      await _storageService.saveSettings(
        speed: _speed,
        fontSize: _fontSize,
        isMirrored: _isMirrored,
        autoSave: true,
        autoSaveDelay: 500,
      );
    } catch (e) {
      // Ігноруємо помилки збереження
    }
  }
  
  // Перемикання старт/пауза
  void _togglePlayPause() {
    setState(() => _isPlaying = !_isPlaying);
    
    if (_isPlaying) {
      _startScrolling();
    } else {
      _stopScrolling();
    }
  }
  
  // Показ/приховування панелі керування
  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }
  
  // Запуск прокрутки
  void _startScrolling() {
    if (!_isPlaying) return;
    
    _scrollToNextPosition();
  }
  
  // Зупинка прокрутки
  void _stopScrolling() {
    setState(() => _isPlaying = false);
  }
  
  // Прокрутка до наступної позиції
  void _scrollToNextPosition() {
    if (!_isPlaying || !_scrollController.hasClients) return;
    
    final currentOffset = _scrollController.offset;
    final maxOffset = _scrollController.position.maxScrollExtent;
    final newOffset = currentOffset + (_speed * 0.5);
    
    if (newOffset <= maxOffset) {
      _scrollController.animateTo(
        newOffset,
        duration: Duration(milliseconds: (100 / _speed).round()),
        curve: Curves.linear,
      ).then((_) {
        // Рекурсивно продовжуємо прокрутку
        if (_isPlaying) {
          Future.delayed(Duration(milliseconds: (50 / _speed).round()), () {
            if (mounted && _isPlaying) {
              _scrollToNextPosition();
            }
          });
        }
      });
    } else {
      _stopScrolling();
    }
  }
  
  // Зміна швидкості
  void _onSpeedChanged(double speed) {
    setState(() => _speed = speed);
    _saveSettings();
  }
  
  // Зміна розміру шрифту
  void _onFontSizeChanged(double fontSize) {
    setState(() => _fontSize = fontSize);
    _saveSettings();
  }
  
  // Зміна дзеркального режиму
  void _onMirrorChanged(bool isMirrored) {
    setState(() => _isMirrored = isMirrored);
    _saveSettings();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: _togglePlayPause,
        onDoubleTap: _toggleControls,
        child: Stack(
          children: [
            // Основний текст
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(_isMirrored ? 3.14159 : 0),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    widget.scriptText,
                    style: AppTypography.body1.copyWith(
                      color: AppColors.onBackground,
                      fontSize: _fontSize,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ),
            
            // Індикатор стану
            Positioned(
              top: AppSpacing.lg,
              right: AppSpacing.lg,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.overlay,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: AppColors.onBackground,
                  size: 20,
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
    );
  }
}
