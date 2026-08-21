/// Application-wide constants according to PRD, ARCHITECTURE, and RULES.
class AppConstants {
  AppConstants._();

  static const String appName = 'Silent Memory Team Management';

  /// Standard timezone for all business logic (Asia/Makassar / WITA / UTC+08:00)
  static const String timeZoneName = 'Asia/Makassar';
  static const int timeZoneOffsetHours = 8;

  /// User Roles
  static const String roleMember = 'member';
  static const String roleAdmin = 'admin';
  static const String roleSuperAdmin = 'super_admin';

  /// User Statuses
  static const String userStatusActive = 'active';
  static const String userStatusInactive = 'inactive';

  /// Performance Statuses
  static const String statusDone = 'DONE';
  static const String statusLate = 'LATE';
  static const String statusVeryLate = 'VERY_LATE';
  static const String statusNotDone = 'NOT_DONE';
  static const String statusNotAssigned = 'NOT_ASSIGNED';

  /// Achievement Weights
  static const double weightDone = 1.00;
  static const double weightLate = 0.75;
  static const double weightVeryLate = 0.50;
  static const double weightNotDone = 0.00;

  /// Payroll Period Statuses (per SCHEMA.md)
  static const String payrollPeriodDraft = 'DRAFT';
  static const String payrollPeriodOpen = 'OPEN';
  static const String payrollPeriodCalculated = 'CALCULATED';
  static const String payrollPeriodApproved = 'APPROVED';
  static const String payrollPeriodLocked = 'LOCKED';

  /// Payroll Item Statuses
  static const String payrollDraft = 'DRAFT';
  static const String payrollCalculated = 'CALCULATED';
  static const String payrollApproved = 'APPROVED';
  static const String payrollLocked = 'LOCKED';
}
