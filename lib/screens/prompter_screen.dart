import 'package:flutter/material.dart';
import '../controllers/prompter_controller.dart';
import '../widgets/prompter_control_panel.dart';

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
  late final PrompterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PrompterController();
    _controller.initialize();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }
  
  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        title: const Text('Суфлер'),
        backgroundColor: const Color(0xFF000000),
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
            onPressed: _controller.toggleSpeedControl,
            tooltip: 'Налаштування швидкості',
          ),
          // Кнопка дзеркального режиму
          IconButton(
            icon: Icon(_controller.settings.isMirrored ? Icons.flip : Icons.flip_outlined),
            onPressed: () => _controller.updateMirrorMode(!_controller.settings.isMirrored),
            tooltip: _controller.settings.isMirrored ? 'Вимкнути дзеркало' : 'Увімкнути дзеркало',
          ),
          // Кнопка старт/пауза
          IconButton(
            icon: Icon(_controller.isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _controller.togglePlayPause,
            tooltip: _controller.isPlaying ? 'Пауза' : 'Старт',
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF000000),
        child: Stack(
          children: [
            // Основний текст з можливістю тапу
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                controller: _controller.scrollController,
                physics: const ClampingScrollPhysics(),
                child: GestureDetector(
                  onTap: _controller.togglePlayPause,
                  behavior: HitTestBehavior.opaque,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..scale(
                      _controller.settings.isMirrored ? -1.0 : 1.0, 
                      1.0
                    ),
                    child: Text(
                      widget.scriptText,
                      style: TextStyle(
                        color: const Color(0xFFFFFFFF),
                        fontSize: _controller.settings.fontSize,
                        height: 1.6,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Countdown індикатор
            if (_controller.isCountdown)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _controller.countdownValue > 0 
                            ? _controller.countdownValue.toString()
                            : 'Старт!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _controller.settings.fontSize * 3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Приготуйтеся...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
            // Панель керування
            if (_controller.showSpeedControl)
              PrompterControlPanel(
                settings: _controller.settings,
                onSpeedChanged: _controller.updateSpeed,
                onFontSizeChanged: _controller.updateFontSize,
                onDelayChanged: _controller.updateStartDelay,
              ),
          ],
        ),
      ),
    );
  }
}
