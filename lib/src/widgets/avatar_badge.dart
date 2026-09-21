import 'package:flutter/material.dart';

/// Renders a notification count, status dot, or custom badge for `CachedAvatar`.
class AvatarBadge extends StatelessWidget {
  /// Custom text string to display inside the badge.
  final String? badgeText;

  /// Numeric count to display inside the badge.
  final int? badgeCount;

  /// Maximum count before appending `+` (e.g., 99+). Defaults to 99.
  final int badgeLimit;

  /// Background color of the badge. Defaults to [ColorScheme.error].
  final Color? badgeColor;

  /// Custom text style for the badge label.
  final TextStyle? badgeTextStyle;

  /// Explicit diameter/height of the badge. Proportionally calculated if null.
  final double? badgeSize;

  /// Alignment of the badge relative to the avatar bounds. Defaults to [Alignment.topRight].
  final Alignment badgeAlignment;

  /// Custom badge widget to render in place of the default badge layout.
  final Widget? customBadge;

  /// The minimum dimension of the avatar, used for responsive scaling.
  final double? minDimension;

  const AvatarBadge({
    super.key,
    this.badgeText,
    this.badgeCount,
    this.badgeLimit = 99,
    this.badgeColor,
    this.badgeTextStyle,
    this.badgeSize,
    this.badgeAlignment = Alignment.topRight,
    this.customBadge,
    this.minDimension,
  });

  /// Helper utility to determine whether a badge should be rendered.
  static bool shouldRender({
    bool showBadge = false,
    String? badgeText,
    int? badgeCount,
    Widget? customBadge,
  }) {
    return showBadge ||
        badgeText != null ||
        badgeCount != null ||
        customBadge != null;
  }

  @override
  Widget build(BuildContext context) {
    if (customBadge != null) return customBadge!;

    final theme = Theme.of(context);
    final isCountOrText = badgeText != null || badgeCount != null;
    final defaultSize = isCountOrText
        ? ((minDimension ?? 40.0) * 0.35).clamp(18.0, 36.0)
        : ((minDimension ?? 40.0) * 0.25).clamp(10.0, 24.0);
    final size = badgeSize ?? defaultSize;
    final color = badgeColor ?? theme.colorScheme.error;
    final borderWidth = (size * 0.08).clamp(1.5, 2.5);
    String? contentStr;

    if (badgeText != null) {
      contentStr = badgeText;
    } else if (badgeCount != null) {
      contentStr =
          badgeCount! > badgeLimit ? '$badgeLimit+' : badgeCount.toString();
    }

    final offset = size * 0.15;

    final Widget badgeContent;
    if (contentStr != null) {
      badgeContent = Container(
        padding: EdgeInsets.symmetric(horizontal: size * 0.22, vertical: 1.0),
        constraints: BoxConstraints(minWidth: size, minHeight: size),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size),
          border: Border.all(
            color: theme.scaffoldBackgroundColor,
            width: borderWidth,
          ),
        ),
        child: Center(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: Text(
            contentStr,
            style: badgeTextStyle ??
                TextStyle(
                  color: Colors.white,
                  fontSize: (size * 0.58).clamp(10.0, 20.0),
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      badgeContent = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.scaffoldBackgroundColor,
            width: borderWidth,
          ),
        ),
      );
    }

    return Transform.translate(
      offset: Offset(
        badgeAlignment.x > 0 ? offset : (badgeAlignment.x < 0 ? -offset : 0),
        badgeAlignment.y > 0 ? offset : (badgeAlignment.y < 0 ? -offset : 0),
      ),
      child: badgeContent,
    );
  }
}
