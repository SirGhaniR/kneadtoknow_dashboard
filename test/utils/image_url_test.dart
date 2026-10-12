import 'package:flutter_test/flutter_test.dart';
import 'package:kneadtoknow_admin/config/api_config.dart';
import 'package:kneadtoknow_admin/utils/image_url.dart';

void main() {
  group('imageUrl', () {
    test('returns empty string when filename is null', () {
      expect(imageUrl(null), '');
    });

    test('returns empty string when filename is empty', () {
      expect(imageUrl(''), '');
    });

    test('builds full URL for a valid filename', () {
      const filename = 'sourdough_loaf.jpg';
      final result = imageUrl(filename);
      expect(result, '${ApiConfig.imageBaseUrl}/$filename');
    });

    test('URL contains the base from ApiConfig', () {
      final result = imageUrl('a.png');
      expect(result, startsWith(ApiConfig.imageBaseUrl));
    });

    test('preserves filename with spaces and special characters', () {
      const filename = 'loaf 2 (final).jpg';
      final result = imageUrl(filename);
      expect(result, endsWith(filename));
    });
  });
}
