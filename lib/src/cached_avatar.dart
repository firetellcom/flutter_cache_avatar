import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'utils/avatar_color_generator.dart';
import 'utils/gravatar_helper.dart';
import 'utils/initials_formatter.dart';
import 'widgets/avatar_badge.dart';
import 'widgets/avatar_fallback.dart';

/// A production-grade cached image widget with support for:
/// - Custom dimensions (`width`, `height`, or `size`)
/// - Circular or rounded-rectangle shapes with customizable borders
/// - Fallback text (user initials for avatars) when URL is null/empty or on error
/// - Gravatar fallback via `email`
/// - Dynamic background colors via `colorize`
/// - Badges for status, unread counts, etc.
class CachedAvatar extends StatelessWidget {
  // Default fallback background colors
  static const _darkFallbackBg = Color(0xFF24242A);
  static const _lightFallbackBg = Color(0xFFF2F2F7);

  final String? imageUrl;
  final String? email;
  final String? name;
  final double? width;
  final double? height;
  final double? radius;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape shape;
  final BoxBorder? border;
  final BoxFit fit;
  final Color? backgroundColor;
  final bool colorize;

  /// Optional custom text style for auto-generated initials.
  final TextStyle? textStyle;

  /// Custom builder for the loading placeholder.
  final Widget Function(BuildContext context, String url)? placeholder;

  /// Custom builder for error state.
  final Widget Function(BuildContext context, String url, Object error)?
  errorWidget;

  /// Custom widget displayed when [imageUrl] is null or empty.
  final Widget? emptyWidget;

  // Badge properties
  final bool showBadge;
  final String? badgeText;
  final int? badgeCount;
  final int badgeLimit;
  final Color? badgeColor;
  final TextStyle? badgeTextStyle;
  final double? badgeSize;
  final Alignment badgeAlignment;
  final Widget? customBadge;

  /// Default circular avatar constructor.
  ///
  /// Can be sized using [size] (defaults to 40.0) or specific [width] and [height].
  const CachedAvatar({
    super.key,
    this.imageUrl,
    this.email,
    this.name,
    double? size,
    double? width,
    double? height,
    this.radius,
    this.borderRadius,
    this.shape = BoxShape.circle,
    this.border,
    this.fit = BoxFit.cover,
    this.backgroundColor,
    this.colorize = false,
    this.textStyle,
    this.placeholder,
    this.errorWidget,
    this.emptyWidget,
    this.showBadge = false,
    this.badgeText,
    this.badgeCount,
    this.badgeLimit = 99,
    this.badgeColor,
    this.badgeTextStyle,
    this.badgeSize,
    this.badgeAlignment = Alignment.topRight,
    this.customBadge,
  }) : width = size ?? width ?? 40.0,
       height = size ?? height ?? 40.0;

  /// Circular image / avatar constructor with custom size.
  const CachedAvatar.circle({
    super.key,
    this.imageUrl,
    this.email,
    this.name,
    double size = 40.0,
    this.border,
    this.fit = BoxFit.cover,
    this.backgroundColor,
    this.colorize = false,
    this.textStyle,
    this.placeholder,
    this.errorWidget,
    this.emptyWidget,
    this.showBadge = false,
    this.badgeText,
    this.badgeCount,
    this.badgeLimit = 99,
    this.badgeColor,
    this.badgeTextStyle,
    this.badgeSize,
    this.badgeAlignment = Alignment.topRight,
    this.customBadge,
  }) : width = size,
       height = size,
       radius = null,
       borderRadius = null,
       shape = BoxShape.circle;

  /// Rounded-rectangle avatar constructor with custom corner radius.
  const CachedAvatar.rounded({
    super.key,
    this.imageUrl,
    this.email,
    this.name,
    double? size,
    double? width,
    double? height,
    double radius = 12.0,
    this.borderRadius,
    this.border,
    this.fit = BoxFit.cover,
    this.backgroundColor,
    this.colorize = false,
    this.textStyle,
    this.placeholder,
    this.errorWidget,
    this.emptyWidget,
    this.showBadge = false,
    this.badgeText,
    this.badgeCount,
    this.badgeLimit = 99,
    this.badgeColor,
    this.badgeTextStyle,
    this.badgeSize,
    this.badgeAlignment = Alignment.topRight,
    this.customBadge,
  }) : width = size ?? width ?? 40.0,
       height = size ?? height ?? 40.0,
       radius = borderRadius == null ? radius : null,
       shape = BoxShape.rectangle;

  /// Square / rectangular avatar constructor.
  const CachedAvatar.square({
    super.key,
    this.imageUrl,
    this.email,
    this.name,
    double size = 40.0,
    this.border,
    this.fit = BoxFit.cover,
    this.backgroundColor,
    this.colorize = false,
    this.textStyle,
    this.placeholder,
    this.errorWidget,
    this.emptyWidget,
    this.showBadge = false,
    this.badgeText,
    this.badgeCount,
    this.badgeLimit = 99,
    this.badgeColor,
    this.badgeTextStyle,
    this.badgeSize,
    this.badgeAlignment = Alignment.topRight,
    this.customBadge,
  }) : width = size,
       height = size,
       radius = null,
       borderRadius = null,
       shape = BoxShape.rectangle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String? resolvedUrl = _resolveUrl();
    final bool hasValidUrl = resolvedUrl != null && resolvedUrl.isNotEmpty;
    final String? fallbackText = InitialsFormatter.format(name);

    final Widget fallbackWidget = AvatarFallback(
      fallbackText: fallbackText,
      shape: shape,
      textStyle: textStyle,
      fontSize: _fontSize,
      iconSize: _iconSize,
      colorize: colorize,
      backgroundColor: backgroundColor,
    );

    final Widget imageWidget = Container(
      width: width,
      height: height,
      decoration: _buildDecoration(theme, fallbackText),
      clipBehavior: Clip.antiAlias,
      child: hasValidUrl
          ? CachedNetworkImage(
              imageUrl: resolvedUrl,
              width: width,
              height: height,
              fit: fit,
              placeholder:
                  placeholder ??
                  (context, url) => _buildLoadingIndicator(theme),
              errorWidget:
                  errorWidget ??
                  (context, url, error) => fallbackWidget,
            )
          : (emptyWidget ?? fallbackWidget),
    );

    if (!_hasBadge) {
      return imageWidget;
    }

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          imageWidget,
          Positioned.fill(
            child: Align(
              alignment: badgeAlignment,
              child: AvatarBadge(
                badgeText: badgeText,
                badgeCount: badgeCount,
                badgeLimit: badgeLimit,
                badgeColor: badgeColor,
                badgeTextStyle: badgeTextStyle,
                badgeSize: badgeSize,
                badgeAlignment: badgeAlignment,
                customBadge: customBadge,
                minDimension: _minDimension,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // URL Resolution
  // ---------------------------------------------------------------------------

  String? _resolveUrl() {
    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      return imageUrl!.trim();
    }
    if (email != null && email!.trim().isNotEmpty) {
      final sizeParam = (_minDimension ?? 50.0).toInt();
      return GravatarHelper.resolveUrl(email, size: sizeParam);
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Private Builders & Helpers
  // ---------------------------------------------------------------------------

  BoxDecoration _buildDecoration(ThemeData theme, String? fallbackText) {
    final isDark = theme.brightness == Brightness.dark;
    final hasText = fallbackText != null && fallbackText.isNotEmpty;

    Color? finalBgColor = backgroundColor;
    if (finalBgColor == null) {
      if (colorize && hasText) {
        finalBgColor = AvatarColorGenerator.generate(name ?? fallbackText);
      } else {
        finalBgColor = hasText
            ? theme.colorScheme.primary.withValues(alpha: isDark ? 0.18 : 0.10)
            : (isDark ? _darkFallbackBg : _lightFallbackBg);
      }
    }

    return BoxDecoration(
      color: finalBgColor,
      shape: shape,
      borderRadius: shape == BoxShape.circle ? null : _effectiveBorderRadius,
      border: border,
    );
  }

  BorderRadiusGeometry? get _effectiveBorderRadius {
    if (borderRadius != null) return borderRadius;
    if (radius != null) return BorderRadius.circular(radius!);
    return null;
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Center(
      child: SizedBox(
        width: _indicatorSize,
        height: _indicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: theme.colorScheme.primary.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  bool get _hasBadge => AvatarBadge.shouldRender(
    showBadge: showBadge,
    badgeText: badgeText,
    badgeCount: badgeCount,
    customBadge: customBadge,
  );

  // ---------------------------------------------------------------------------
  // Sizing Calculation
  // ---------------------------------------------------------------------------

  double? get _minDimension {
    if (width != null && height != null) {
      return width! < height! ? width! : height!;
    }
    return width ?? height;
  }

  double get _indicatorSize =>
      (_minDimension != null ? _minDimension! * 0.35 : 18.0).clamp(12.0, 32.0);

  double get _iconSize =>
      (_minDimension != null ? _minDimension! * 0.45 : 20.0).clamp(14.0, 48.0);

  double get _fontSize =>
      (_minDimension != null ? _minDimension! * 0.38 : 14.0).clamp(10.0, 36.0);
}
