import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cache_avatar/src/utils/initials_formatter.dart';

void main() {
  group('InitialsFormatter', () {
    test('returns null for null name', () {
      expect(InitialsFormatter.format(null), isNull);
    });

    test('returns null for empty or whitespace-only name', () {
      expect(InitialsFormatter.format(''), isNull);
      expect(InitialsFormatter.format('   '), isNull);
      expect(InitialsFormatter.format('\t\n'), isNull);
    });

    test('returns single uppercase initial for single word name', () {
      expect(InitialsFormatter.format('alice'), equals('A'));
      expect(InitialsFormatter.format('Bob'), equals('B'));
    });

    test('returns first and last initials for two words', () {
      expect(InitialsFormatter.format('John Doe'), equals('JD'));
      expect(InitialsFormatter.format('jane doe'), equals('JD'));
    });

    test('returns first and last initials for three or more words', () {
      expect(
        InitialsFormatter.format('John Fitzgerald Kennedy'),
        equals('JK'),
      );
      expect(InitialsFormatter.format('Vu Quang Huy'), equals('VH'));
    });

    test('handles leading, trailing, and multiple consecutive spaces', () {
      expect(
        InitialsFormatter.format('   Jane    Smith   '),
        equals('JS'),
      );
    });
  });
}
