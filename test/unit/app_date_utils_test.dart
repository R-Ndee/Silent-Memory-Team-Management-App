import 'package:flutter_test/flutter_test.dart';
import 'package:silent_memory_app/core/utils/app_date_utils.dart';

void main() {
  group('AppDateUtils Tests', () {
    test('isFutureDate correctly identifies future dates', () {
      final now = DateTime(2026, 8, 15, 10, 0);
      final futureDate = DateTime(2026, 8, 16, 8, 0);
      final pastDate = DateTime(2026, 8, 14, 20, 0);
      final sameDayLaterTime = DateTime(2026, 8, 15, 23, 59);

      expect(AppDateUtils.isFutureDate(futureDate, now), isTrue);
      expect(AppDateUtils.isFutureDate(pastDate, now), isFalse);
      expect(AppDateUtils.isFutureDate(sameDayLaterTime, now), isFalse);
    });

    test('formatDisplayDate formats correctly', () {
      final date = DateTime(2026, 8, 12);
      expect(AppDateUtils.formatDisplayDate(date), equals('12 August 2026'));
    });

    test('formatRupiah formats Indonesian currency correctly', () {
      expect(AppDateUtils.formatRupiah(150000), contains('150.000'));
      expect(AppDateUtils.formatRupiah(20000), contains('20.000'));
    });
  });
}
