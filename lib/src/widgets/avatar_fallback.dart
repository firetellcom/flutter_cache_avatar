import 'package:flutter/material.dart';

/// Renders the fallback content (initials text or placeholder icon) for `CachedAvatar`.
class AvatarFallback extends StatelessWidget {
  /// The initials text to display, if available.
  final String? fallbackText;

  /// Shape of the avatar, determining whether a person or image icon is shown when text is absent.
  final BoxShape shape;

  /// Custom text style for the fallback initials text.
  final TextStyle? textStyle;

  /// Computed font size proportional to avatar dimensions.
  final double fontSize;

  /// Computed icon size proportional to avatar dimensions.
  final double iconSize;

  /// Whether dynamic background colorization is active.
  final bool colorize;

  /// Explicit background color if set on the parent avatar.
  final Color? backgroundColor;

  const AvatarFallback({
    super.key,
    this.fallbackText,
    this.shape = BoxShape.circle,
    this.textStyle,
    required this.fontSize,
    required this.iconSize,
    this.colorize = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (fallbackText != null && fallbackText!.isNotEmpty) {
      return Center(
        child: Text(
          fallbackText!,
          style: textStyle ??
              TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: colorize && backgroundColor == null
                    ? Colors.white
                    : theme.colorScheme.primary,
                letterSpacing: -0.2,
              ),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      );
    }

    final isDark = theme.brightness == Brightness.dark;
    final defaultIconColor =
        isDark ? const Color(0xFF8E8E93) : const Color(0xFFA1A1A6);

    return Center(
      child: Icon(
        shape == BoxShape.circle ? Icons.person_rounded : Icons.image_outlined,
        size: iconSize,
        color: colorize && backgroundColor == null
            ? Colors.white
            : defaultIconColor,
      ),
    );
  }
}
