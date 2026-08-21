import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// Utilities for handling business date/time calculations in WITA (UTC+8).
class AppDateUtils {
  AppDateUtils._();

  /// Returns current DateTime converted to WITA (UTC+8)
  static DateTime nowInWita() {
    final utcNow = DateTime.now().toUtc();
    return utcNow.add(const Duration(hours: AppConstants.timeZoneOffsetHours));
  }

  /// Converts a UTC DateTime to WITA (UTC+8)
  static DateTime toWita(DateTime dateTime) {
    final utc = dateTime.toUtc();
    return utc.add(const Duration(hours: AppConstants.timeZoneOffsetHours));
  }

  /// Checks if [targetDate] is in the future relative to [currentWitaDate]
  static bool isFutureDate(DateTime targetDate, DateTime currentWitaDate) {
    final targetDateOnly = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final currentDateOnly = DateTime(currentWitaDate.year, currentWitaDate.month, currentWitaDate.day);
    return targetDateOnly.isAfter(currentDateOnly);
  }

  /// Formats date to display format e.g. "12 August 2026"
  static String formatDisplayDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  /// Formats date to ISO date string "yyyy-MM-dd"
  static String formatIsoDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Formats time string e.g. "08:30 WITA"
  static String formatDisplayTime(DateTime dateTime) {
    return '${DateFormat('HH:mm').format(dateTime)} WITA';
  }

  /// Formats currency to Indonesian Rupiah e.g. "Rp150.000"
  static String formatRupiah(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}
