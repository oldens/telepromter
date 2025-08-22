import 'package:flutter/material.dart';
import 'package:simple_prompter/constants/app_colors.dart';
import 'package:simple_prompter/constants/app_spacing.dart';
import 'package:simple_prompter/constants/app_typography.dart';

class ControlPanel extends StatelessWidget {
  final double speed;
  final double fontSize;
  final bool isMirrored;
  final ValueChanged<double> onSpeedChanged;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<bool> onMirrorChanged;
  
  const ControlPanel({
    super.key,
    required this.speed,
    required this.fontSize,
    required this.isMirrored,
    required this.onSpeedChanged,
    required this.onFontSizeChanged,
    required this.onMirrorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.divider,
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Заголовок
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Налаштування',
                style: AppTypography.h3.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  // TODO: Закрити панель
                },
                color: AppColors.onSurface,
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          // Швидкість прокрутки
          _buildSliderControl(
            label: 'Швидкість',
            value: speed,
            min: 0.5,
            max: 3.0,
            divisions: 25,
            icon: Icons.speed,
            onChanged: onSpeedChanged,
            valueLabel: '${speed.toStringAsFixed(1)}x',
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          // Розмір шрифту
          _buildSliderControl(
            label: 'Розмір шрифту',
            value: fontSize,
            min: 14.0,
            max: 32.0,
            divisions: 18,
            icon: Icons.text_fields,
            onChanged: onFontSizeChanged,
            valueLabel: '${fontSize.round()}px',
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          // Дзеркальний режим
          _buildSwitchControl(
            label: 'Дзеркальний режим',
            value: isMirrored,
            icon: Icons.flip,
            onChanged: onMirrorChanged,
          ),
        ],
      ),
    );
  }
  
  // Створення слайдера
  Widget _buildSliderControl({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required IconData icon,
    required ValueChanged<double> onChanged,
    required String valueLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: AppTypography.body1.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                valueLabel,
                style: AppTypography.caption.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.divider,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withOpacity(0.2),
            valueIndicatorColor: AppColors.primary,
            valueIndicatorTextStyle: AppTypography.caption.copyWith(
              color: AppColors.onPrimary,
            ),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            label: valueLabel,
          ),
        ),
      ],
    );
  }
  
  // Створення перемикача
  Widget _buildSwitchControl({
    required String label,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: AppTypography.body1.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
          activeTrackColor: AppColors.primary.withOpacity(0.3),
          inactiveThumbColor: AppColors.disabled,
          inactiveTrackColor: AppColors.divider,
        ),
      ],
    );
  }
}
