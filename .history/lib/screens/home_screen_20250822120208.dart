import 'package:flutter/material.dart';
import 'package:simple_prompter/services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  final StorageService _storageService = StorageService();
  bool _hasText = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
    _loadScript();
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  // Завантаження збереженого сценарію
  Future<void> _loadScript() async {
    setState(() => _isLoading = true);
    
    try {
      final savedText = await _storageService.loadScript();
      if (savedText != null) {
        _textController.text = savedText;
        _updateTextState();
      }
    } catch (e) {
      print('Помилка завантаження: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Обробка зміни тексту
  void _onTextChanged() {
    _updateTextState();
    
    // Автозбереження при зміні тексту
    if (_textController.text.isNotEmpty) {
      _saveScript();
    }
  }

  // Оновлення стану тексту
  void _updateTextState() {
    final hasText = _textController.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  // Збереження сценарію
  Future<void> _saveScript() async {
    try {
      await _storageService.saveScript(_textController.text);
    } catch (e) {
      print('Помилка збереження: $e');
    }
  }

  // Запуск суфлера (поки без функціональності)
  void _startPrompter() {
    if (!_hasText) return;
    
    // TODO: Перехід на екран суфлера
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Функція суфлера буде додана в наступному кроці!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Простий Суфлер'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Поле введення тексту
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: 'Введіть ваш сценарій тут...',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Кнопка Старт
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _hasText ? _startPrompter : null,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text(
                        'Старт',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _hasText ? Colors.blue : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
