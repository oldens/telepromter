import 'package:flutter/material.dart';
import 'dart:async';
import 'package:simple_prompter/services/storage_service.dart';

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
  Timer? _scrollTimer;
  bool _isPlaying = false;
  double _speed = 1.0; // пікселів за секунду
  double _fontSize = 18.0; // розмір шрифту
  bool _showSpeedControl = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // Завантаження збережених налаштувань
  Future<void> _loadSettings() async {
    try {
      final savedSpeed = await _storageService.loadSpeed();
      final savedFontSize = await _storageService.loadFontSize();
      setState(() {
        _speed = savedSpeed;
        _fontSize = savedFontSize;
      });
    } catch (e) {
      print('Помилка завантаження налаштувань: $e');
    }
  }

  // Збереження швидкості
  Future<void> _saveSpeed(double speed) async {
    try {
      await _storageService.saveSpeed(speed);
    } catch (e) {
      print('Помилка збереження швидкості: $e');
    }
  }

  // Запуск/зупинка прокрутки
  void _togglePlayPause() {
    setState(() => _isPlaying = !_isPlaying);
    
    if (_isPlaying) {
      _startScrolling();
    } else {
      _stopScrolling();
    }
  }

  // Показ/приховування контролю швидкості
  void _toggleSpeedControl() {
    setState(() => _showSpeedControl = !_showSpeedControl);
  }

  // Зміна швидкості
  void _onSpeedChanged(double speed) {
    setState(() => _speed = speed);
    _saveSpeed(speed);
  }

  // Збереження розміру шрифту
  Future<void> _saveFontSize(double fontSize) async {
    try {
      await _storageService.saveFontSize(fontSize);
    } catch (e) {
      print('Помилка збереження розміру шрифту: $e');
    }
  }

  // Зміна розміру шрифту
  void _onFontSizeChanged(double fontSize) {
    setState(() => _fontSize = fontSize);
    _saveFontSize(fontSize);
  }

  // Запуск прокрутки
  void _startScrolling() {
    if (!_isPlaying) return;
    
    _scrollTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (!_isPlaying) {
        timer.cancel();
        return;
      }
      
      _scrollToNextPosition();
    });
  }

  // Зупинка прокрутки
  void _stopScrolling() {
    _scrollTimer?.cancel();
    _scrollTimer = null;
  }

  // Прокрутка до наступної позиції
  void _scrollToNextPosition() {
    if (!_isPlaying || !_scrollController.hasClients) return;
    
    final currentOffset = _scrollController.offset;
    final maxOffset = _scrollController.position.maxScrollExtent;
    final newOffset = currentOffset + (_speed * 0.3); // Зменшено крок для плавності
    
    if (newOffset <= maxOffset) {
      _scrollController.animateTo(
        newOffset,
        duration: Duration(milliseconds: (200 / _speed).round()), // Збільшено тривалість
        curve: Curves.easeOut, // Змінено на easeOut для плавності
      );
    } else {
      // Дійшли до кінця - зупиняємо
      setState(() => _isPlaying = false);
      _stopScrolling();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000), // Повністю непрозорий чорний
      appBar: AppBar(
        title: const Text('Суфлер'),
        backgroundColor: const Color(0xFF000000), // Повністю непрозорий чорний
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Кнопка налаштувань швидкості
          IconButton(
            icon: const Icon(Icons.speed),
            onPressed: _toggleSpeedControl,
            tooltip: 'Налаштування швидкості',
          ),
          // Кнопка старт/пауза
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _togglePlayPause,
            tooltip: _isPlaying ? 'Пауза' : 'Старт',
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF000000), // Додатковий чорний фон
        child: Stack(
          children: [
            // Основний текст
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(), // Додано для плавності
                                 child: Text(
                   widget.scriptText,
                   style: TextStyle(
                     color: const Color(0xFFFFFFFF), // Повністю непрозорий білий
                     fontSize: _fontSize,
                     height: 1.6,
                     fontWeight: FontWeight.normal,
                   ),
                 ),
              ),
            ),
            
            // Контроль швидкості
            if (_showSpeedControl)
              Positioned(
                top: 20,
                right: 20,
                                 child: Container(
                   width: 220,
                   padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF000000), // Повністю непрозорий чорний
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.speed, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Швидкість: ${_speed.toStringAsFixed(1)}x',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.blue,
                          inactiveTrackColor: Colors.grey[600],
                          thumbColor: Colors.blue,
                          overlayColor: Colors.blue.withOpacity(0.2),
                          valueIndicatorColor: Colors.blue,
                          valueIndicatorTextStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                                                 child: Slider(
                           value: _speed,
                           min: 0.5,
                           max: 10.0,
                           divisions: 95, // (10.0 - 0.5) * 10 = 95
                           onChanged: _onSpeedChanged,
                           label: '${_speed.toStringAsFixed(1)}x',
                         ),
                       ),
                       
                       const SizedBox(height: 16),
                       
                       // Розмір шрифту
                       Row(
                         children: [
                           const Icon(Icons.text_fields, color: Colors.white, size: 20),
                           const SizedBox(width: 8),
                           Text(
                             'Шрифт: ${_fontSize.round()}px',
                             style: const TextStyle(
                               color: Colors.white,
                               fontSize: 14,
                               fontWeight: FontWeight.w500,
                             ),
                           ),
                         ],
                       ),
                       const SizedBox(height: 12),
                       SliderTheme(
                         data: SliderTheme.of(context).copyWith(
                           activeTrackColor: Colors.green,
                           inactiveTrackColor: Colors.grey[600],
                           thumbColor: Colors.green,
                           overlayColor: Colors.green.withOpacity(0.2),
                           valueIndicatorColor: Colors.green,
                           valueIndicatorTextStyle: const TextStyle(
                             color: Colors.white,
                             fontSize: 12,
                           ),
                         ),
                         child: Slider(
                           value: _fontSize,
                           min: 14.0,
                           max: 64.0,
                           divisions: 50, // (64 - 14) = 50
                           onChanged: _onFontSizeChanged,
                           label: '${_fontSize.round()}px',
                         ),
                       ),
                     ],
                   ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
