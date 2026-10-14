import 'package:flutter_test/flutter_test.dart';
import 'package:kneadtoknow_admin/utils/time_ago.dart';

void main() {
  group('timeAgo', () {
    final now = DateTime(2026, 10, 14, 12, 0, 0);

    test('returns "baru saja" for just now', () {
      expect(timeAgo(now, now: now), 'baru saja');
    });

    test('returns "baru saja" for 30 seconds ago', () {
      final t = now.subtract(const Duration(seconds: 30));
      expect(timeAgo(t, now: now), 'baru saja');
    });

    test('returns "baru saja" at 59 seconds ago', () {
      final t = now.subtract(const Duration(seconds: 59));
      expect(timeAgo(t, now: now), 'baru saja');
    });

    test('returns "1 menit yang lalu" at 60 seconds ago', () {
      final t = now.subtract(const Duration(seconds: 60));
      expect(timeAgo(t, now: now), '1 menit yang lalu');
    });

    test('returns "1 menit yang lalu" for 90 seconds ago', () {
      final t = now.subtract(const Duration(seconds: 90));
      expect(timeAgo(t, now: now), '1 menit yang lalu');
    });

    test('returns "59 menit yang lalu" at 59 minutes', () {
      final t = now.subtract(const Duration(minutes: 59));
      expect(timeAgo(t, now: now), '59 menit yang lalu');
    });

    test('returns "1 jam yang lalu" at 60 minutes', () {
      final t = now.subtract(const Duration(minutes: 60));
      expect(timeAgo(t, now: now), '1 jam yang lalu');
    });

    test('returns "23 jam yang lalu" at 23 hours', () {
      final t = now.subtract(const Duration(hours: 23));
      expect(timeAgo(t, now: now), '23 jam yang lalu');
    });

    test('returns "1 hari yang lalu" at 24 hours', () {
      final t = now.subtract(const Duration(hours: 24));
      expect(timeAgo(t, now: now), '1 hari yang lalu');
    });

    test('returns "29 hari yang lalu" at 29 days', () {
      final t = now.subtract(const Duration(days: 29));
      expect(timeAgo(t, now: now), '29 hari yang lalu');
    });

    test('returns "1 bulan yang lalu" at 30 days', () {
      final t = now.subtract(const Duration(days: 30));
      expect(timeAgo(t, now: now), '1 bulan yang lalu');
    });

    test('returns "12 bulan yang lalu" at 364 days', () {
      final t = now.subtract(const Duration(days: 364));
      expect(timeAgo(t, now: now), '12 bulan yang lalu');
    });

    test('returns "1 tahun yang lalu" at 365 days', () {
      final t = now.subtract(const Duration(days: 365));
      expect(timeAgo(t, now: now), '1 tahun yang lalu');
    });

    test('returns "2 tahun yang lalu" at 730 days', () {
      final t = now.subtract(const Duration(days: 730));
      expect(timeAgo(t, now: now), '2 tahun yang lalu');
    });
  });
}
