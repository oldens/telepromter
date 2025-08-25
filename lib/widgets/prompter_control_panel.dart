import 'package:flutter/material.dart';
import '../models/prompter_settings.dart';

class PrompterControlPanel extends StatelessWidget {
  final PrompterSettings settings;
  final ValueChanged<double> onSpeedChanged;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<double> onDelayChanged;
  
  const PrompterControlPanel({
    super.key,
    required this.settings,
    required this.onSpeedChanged,
    required this.onFontSizeChanged,
    required this.onDelayChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Отримуємо орієнтацію екрану
    final orientation = MediaQuery.of(context).orientation;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Адаптивне позиціонування для горизонтального режиму
    final topPosition = orientation == Orientation.landscape 
        ? 10.0  // Менше відступ зверху в горизонтальному режимі
        : 80.0; // Стандартний відступ у вертикальному режимі
        
    return Positioned(
      top: topPosition,
      left: 20,
      right: 20,
      child: Container(
        padding: orientation == Orientation.landscape 
            ? const EdgeInsets.all(12)  // Менше відступи в горизонтальному режимі
            : const EdgeInsets.all(20), // Стандартні відступи у вертикальному
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // Контроль швидкості
            _buildSliderControl(
              label: 'Швидкість: ${settings.speed.toStringAsFixed(1)}x',
              value: settings.speed,
              min: 0.5,
              max: 10.0,
              divisions: 95,
              onChanged: onSpeedChanged,
            ),
            
            SizedBox(height: orientation == Orientation.landscape ? 8 : 16),
            
            // Контроль розміру шрифту
            _buildSliderControl(
              label: 'Шрифт: ${settings.fontSize.round()}px',
              value: settings.fontSize,
              min: 14.0,
              max: 64.0,
              divisions: 50,
              onChanged: onFontSizeChanged,
            ),
            
            SizedBox(height: orientation == Orientation.landscape ? 8 : 16),
            
            // Контроль затримки запуску
            _buildSliderControl(
              label: 'Затримка: ${settings.startDelay == 0 ? 'Без затримки' : '${settings.startDelay.toStringAsFixed(1)}s'}',
              value: settings.startDelay,
              min: 0.0,
              max: 10.0,
              divisions: 20,
              onChanged: onDelayChanged,
            ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSliderControl({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Builder(
      builder: (context) {
        final orientation = MediaQuery.of(context).orientation;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: orientation == Orientation.landscape ? 14 : 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: orientation == Orientation.landscape ? 4 : 8),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
              label: label.split(': ').last,
            ),
          ],
        );
      },
    );
  }
}
