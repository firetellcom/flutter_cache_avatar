import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cache_avatar/src/utils/avatar_color_generator.dart';

void main() {
  group('AvatarColorGenerator', () {
    test('returns Colors.grey for empty string', () {
      expect(AvatarColorGenerator.generate(''), equals(Colors.grey));
    });

    test('is deterministic for the same input string', () {
      final color1 = AvatarColorGenerator.generate('John Doe');
      final color2 = AvatarColorGenerator.generate('John Doe');
      expect(color1, equals(color2));
    });

    test('generates different colors for different strings', () {
      final colorA = AvatarColorGenerator.generate('Alice');
      final colorB = AvatarColorGenerator.generate('Bob');
      expect(colorA, isNot(equals(colorB)));
    });

    test('applies custom saturation and lightness', () {
      final standard = AvatarColorGenerator.generate('Test');
      final custom = AvatarColorGenerator.generate(
        'Test',
        saturation: 0.90,
        lightness: 0.30,
      );
      expect(standard, isNot(equals(custom)));
    });
  });
}
