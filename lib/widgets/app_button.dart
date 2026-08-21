import 'package:flutter/material.dart';
import '../core/constants/app_radius.dart';
import '../core/theme/app_colors.dart';

enum AppButtonVariant { primary, secondary, destructive }

/// Standardized button component adhering to DESIGN.md hierarchy.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
            disabledForegroundColor: AppColors.onPrimary.withValues(alpha: 0.7),
          ),
          child: _buildChild(context, AppColors.onPrimary),
        );
      case AppButtonVariant.secondary:
        return OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.border, width: 1.0),
          ),
          child: _buildChild(context, AppColors.textPrimary),
        );
      case AppButtonVariant.destructive:
        return ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.onPrimary,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.mediumBorderRadius,
            ),
          ),
          child: _buildChild(context, AppColors.onPrimary),
        );
    }
  }

  Widget _buildChild(BuildContext context, Color color) {
    if (isLoading) {
      return SizedBox(
        height: 20.0,
        width: 20.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18.0, color: color),
          const SizedBox(width: 8.0),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}
