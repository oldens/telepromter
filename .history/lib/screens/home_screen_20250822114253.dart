import 'package:flutter/material.dart';
import 'package:simple_prompter/constants/app_colors.dart';
import 'package:simple_prompter/constants/app_spacing.dart';
import 'package:simple_prompter/constants/app_typography.dart';
import 'package:simple_prompter/services/storage_service.dart';
import 'package:simple_prompter/screens/prompter_screen.dart';
import 'package:simple_prompter/utils/debouncer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  final StorageService _storageService = StorageService();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  
  bool _isLoading = false;
  bool _hasText = false;
  
  @override
  void initState() {
    super.initState();
    _loadScript();
    _textController.addListener(_onTextChanged);
  }
  
  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _debouncer.dispose();
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
      _showErrorSnackBar('Помилка завантаження сценарію: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  // Обробка зміни тексту
  void _onTextChanged() {
    _updateTextState();
    
    // Автозбереження з дебаунсом
    if (_textController.text.isNotEmpty) {
      _debouncer.run(() => _saveScript());
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
      _showErrorSnackBar('Помилка збереження: $e');
    }
  }
  
  // Запуск суфлера
  void _startPrompter() {
    if (!_hasText) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrompterScreen(
          scriptText: _textController.text,
        ),
      ),
    );
  }
  
  // Показ помилки
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Простий Суфлер'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Показати налаштування
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: 'Введіть ваш сценарій тут...',
                        hintStyle: AppTypography.body1.copyWith(
                          color: AppColors.disabled,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                      ),
                      style: AppTypography.body1.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _hasText ? _startPrompter : null,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Старт'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _hasText 
                                ? AppColors.primary 
                                : AppColors.disabled,
                            foregroundColor: AppColors.onPrimary,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
