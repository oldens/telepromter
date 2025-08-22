import 'package:flutter/material.dart';
import 'dart:async';

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
  Timer? _scrollTimer;
  bool _isPlaying = false;
  double _speed = 1.0; // пікселів за секунду

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
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
          // Кнопка старт/пауза
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _togglePlayPause,
            tooltip: _isPlaying ? 'Пауза' : 'Старт',
          ),
        ],
      ),
      body: Padding(
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
    );
  }
}
