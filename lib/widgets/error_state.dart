import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'app_button.dart';

/// Error state component adhering to DESIGN.md §35.
class ErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryButtonText;

  const ErrorState({
    super.key,
    this.title = 'Terjadi Kesalahan',
    required this.message,
    this.onRetry,
    this.retryButtonText = 'Coba Lagi',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: const BoxDecoration(
                color: AppColors.errorBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 36.0,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20.0),
              SizedBox(
                width: 160.0,
                child: AppButton(
                  text: retryButtonText,
                  onPressed: onRetry,
                  variant: AppButtonVariant.secondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
