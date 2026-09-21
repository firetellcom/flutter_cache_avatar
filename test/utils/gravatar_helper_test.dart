import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cache_avatar/src/utils/gravatar_helper.dart';

void main() {
  group('GravatarHelper', () {
    test('returns null for null, empty, or whitespace email', () {
      expect(GravatarHelper.resolveUrl(null), isNull);
      expect(GravatarHelper.resolveUrl(''), isNull);
      expect(GravatarHelper.resolveUrl('   '), isNull);
    });

    test('generates valid gravatar URL with default size', () {
      // MD5 of 'user@example.com' is b58996c504c5638798eb6b511e6f49af
      final url = GravatarHelper.resolveUrl('user@example.com');
      expect(
        url,
        equals(
          'https://www.gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af?s=50&d=404',
        ),
      );
    });

    test('trims and lowercases email before hashing', () {
      final url1 = GravatarHelper.resolveUrl('   USER@Example.COM  ');
      final url2 = GravatarHelper.resolveUrl('user@example.com');
      expect(url1, equals(url2));
    });

    test('respects custom size parameter', () {
      final url = GravatarHelper.resolveUrl('user@example.com', size: 120);
      expect(url, contains('?s=120&d=404'));
    });
  });
}
