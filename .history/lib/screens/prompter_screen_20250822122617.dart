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
  bool _showSpeedControl = false;

  @override
  void initState() {
    super.initState();
    _loadSpeed();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // Завантаження збереженої швидкості
  Future<void> _loadSpeed() async {
    try {
      final savedSpeed = await _storageService.loadSpeed();
      setState(() => _speed = savedSpeed);
    } catch (e) {
      print('Помилка завантаження швидкості: $e');
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

  // Запуск прокрутки
  void _startScrolling() {
    if (!_isPlaying) return;
    
    _scrollTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
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
    final newOffset = currentOffset + (_speed * 0.5);
    
    if (newOffset <= maxOffset) {
      _scrollController.animateTo(
        newOffset,
        duration: Duration(milliseconds: (100 / _speed).round()),
        curve: Curves.linear,
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Суфлер'),
        backgroundColor: Colors.black,
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
      body: Stack(
        children: [
          // Основний текст
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Text(
                widget.scriptText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
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
                width: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 1),
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
                        max: 8.0,
                        divisions: 75, // (8.0 - 0.5) * 10 = 75
                        onChanged: _onSpeedChanged,
                        label: '${_speed.toStringAsFixed(1)}x',
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
