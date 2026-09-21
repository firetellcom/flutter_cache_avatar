import 'package:flutter/material.dart';

/// Utility class to generate consistent, deterministic colors from strings.
abstract final class AvatarColorGenerator {
  /// Default HSL saturation for avatar background colors.
  static const defaultSaturation = 0.75;

  /// Default HSL lightness for avatar background colors.
  static const defaultLightness = 0.50;

  /// Generates a deterministic [Color] from the provided [text].
  ///
  /// The same text will always yield the exact same color across runs.
  /// If [text] is empty, returns [Colors.grey].
  static Color generate(
    String text, {
    double saturation = defaultSaturation,
    double lightness = defaultLightness,
  }) {
    if (text.isEmpty) return Colors.grey;

    int hash = 0;
    for (int i = 0; i < text.length; i++) {
      hash = text.codeUnitAt(i) + ((hash << 5) - hash);
      // Retain 32-bit integer boundaries
      hash = hash & 0xFFFFFFFF;
    }

    final hue = (hash.abs() % 360).toDouble();
    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }
}
