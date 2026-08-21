import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/app_radius.dart';
import '../core/theme/app_colors.dart';

/// Compact status badge following DESIGN.md semantics (DONE, LATE, VERY_LATE, NOT_DONE, NOT_ASSIGNED, etc.).
class StatusBadge extends StatelessWidget {
  final String status;
  final String? customLabel;

  const StatusBadge({
    super.key,
    required this.status,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    final style = _getBadgeStyle(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: AppRadius.pillBorderRadius,
        border: Border.all(color: style.borderColor, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (style.icon != null) ...[
            Icon(style.icon, size: 12.0, color: style.textColor),
            const SizedBox(width: 4.0),
          ],
          Text(
            customLabel ?? _getLabelText(status),
            style: TextStyle(
              color: style.textColor,
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  String _getLabelText(String status) {
    switch (status.toUpperCase()) {
      case AppConstants.statusDone:
        return 'Done';
      case AppConstants.statusLate:
        return 'Late';
      case AppConstants.statusVeryLate:
        return 'Very Late';
      case AppConstants.statusNotDone:
        return 'Not Done';
      case AppConstants.statusNotAssigned:
        return 'Not Assigned';
      case AppConstants.payrollPeriodDraft:
        return 'Draft';
      case AppConstants.payrollPeriodOpen:
        return 'Open';
      case AppConstants.payrollPeriodCalculated:
        return 'Calculated';
      case AppConstants.payrollPeriodApproved:
        return 'Approved';
      case AppConstants.payrollPeriodLocked:
        return 'Locked';
      case AppConstants.userStatusActive:
        return 'Active';
      case AppConstants.userStatusInactive:
        return 'Inactive';
      default:
        return status;
    }
  }

  _BadgeStyle _getBadgeStyle(String status) {
    switch (status.toUpperCase()) {
      case AppConstants.statusDone:
      case AppConstants.payrollPeriodApproved:
      case AppConstants.userStatusActive:
        return const _BadgeStyle(
          backgroundColor: AppColors.successBg,
          textColor: AppColors.successText,
          borderColor: AppColors.success,
          icon: Icons.check_circle_outline,
        );
      case AppConstants.statusLate:
        return const _BadgeStyle(
          backgroundColor: AppColors.warningBg,
          textColor: AppColors.warningText,
          borderColor: AppColors.warning,
          icon: Icons.access_time,
        );
      case AppConstants.statusVeryLate:
        return const _BadgeStyle(
          backgroundColor: AppColors.veryLateBg,
          textColor: AppColors.veryLateText,
          borderColor: AppColors.veryLate,
          icon: Icons.warning_amber_rounded,
        );
      case AppConstants.statusNotDone:
        return const _BadgeStyle(
          backgroundColor: AppColors.errorBg,
          textColor: AppColors.errorText,
          borderColor: AppColors.error,
          icon: Icons.cancel_outlined,
        );
      case AppConstants.statusNotAssigned:
      case AppConstants.userStatusInactive:
        return const _BadgeStyle(
          backgroundColor: AppColors.neutralBg,
          textColor: AppColors.neutralText,
          borderColor: AppColors.border,
          icon: Icons.remove_circle_outline,
        );
      case AppConstants.payrollPeriodLocked:
        return const _BadgeStyle(
          backgroundColor: AppColors.infoBg,
          textColor: AppColors.infoText,
          borderColor: AppColors.info,
          icon: Icons.lock_outline,
        );
      default:
        return const _BadgeStyle(
          backgroundColor: AppColors.surfaceVariant,
          textColor: AppColors.textSecondary,
          borderColor: AppColors.border,
        );
    }
  }
}

class _BadgeStyle {
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final IconData? icon;

  const _BadgeStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    this.icon,
  });
}
