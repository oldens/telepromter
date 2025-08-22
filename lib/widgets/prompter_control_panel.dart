import 'package:flutter/material.dart';
import '../models/prompter_settings.dart';

class PrompterControlPanel extends StatelessWidget {
  final PrompterSettings settings;
  final ValueChanged<double> onSpeedChanged;
  final ValueChanged<double> onFontSizeChanged;
  
  const PrompterControlPanel({
    super.key,
    required this.settings,
    required this.onSpeedChanged,
    required this.onFontSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(20),
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
            
            const SizedBox(height: 16),
            
            // Контроль розміру шрифту
            _buildSliderControl(
              label: 'Шрифт: ${settings.fontSize.round()}px',
              value: settings.fontSize,
              min: 14.0,
              max: 64.0,
              divisions: 50,
              onChanged: onFontSizeChanged,
            ),
          ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
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
  }
}
