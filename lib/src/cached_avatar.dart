import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A production-grade cached image widget with support for:
/// - Custom dimensions (`width`, `height`, or `size` via `.avatar`/`.circle`)
/// - Circular or rounded-rectangle shapes with customizable borders
/// - Fallback text (user initials for avatars) when URL is null/empty or on error
/// - Gravatar fallback via `email`
/// - Dynamic background colors via `colorize`
/// - Badges for status, unread counts, etc.
class CachedAvatar extends StatelessWidget {
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

  const CachedAvatar({
    super.key,
    this.imageUrl,
    this.email,
    this.name,
    this.width,
    this.height,
    this.radius,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
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
  });

  /// Circular image / avatar constructor.
  const CachedAvatar.circle({
    super.key,
    this.imageUrl,
    this.email,
    this.name,
    double? size,
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

  /// Semantic avatar constructor with circular shape.
  const CachedAvatar.avatar({
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String? resolvedUrl = _resolveUrl();
    final bool hasValidUrl = resolvedUrl != null && resolvedUrl.isNotEmpty;

    Widget imageWidget = Container(
      width: width,
      height: height,
      decoration: _buildDecoration(theme),
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
                  (context, url, error) => _buildFallbackContent(theme),
            )
          : (emptyWidget ?? _buildFallbackContent(theme)),
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
            child: Align(alignment: badgeAlignment, child: _buildBadge(theme)),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // URL & Fallback Resolution
  // ---------------------------------------------------------------------------

  String? _resolveUrl() {
    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      return imageUrl!.trim();
    }
    if (email != null && email!.trim().isNotEmpty) {
      final emailHash = md5
          .convert(utf8.encode(email!.toLowerCase().trim()))
          .toString();
      final sizeParam = (_minDimension ?? 50.0).toInt();
      // d=404 ensures it fails to load if gravatar doesn't exist, triggering errorWidget
      return 'https://www.gravatar.com/avatar/$emailHash?s=$sizeParam&d=404';
    }
    return null;
  }

  String? get _effectiveFallbackText {
    if (name != null && name!.trim().isNotEmpty) {
      final words = name!.trim().split(RegExp(r'\s+'));
      if (words.isEmpty) return null;
      String initials = words.first[0];
      if (words.length > 1) {
        initials += words.last[0];
      }
      return initials.toUpperCase();
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Private Builders & Helpers
  // ---------------------------------------------------------------------------

  BoxDecoration _buildDecoration(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final text = _effectiveFallbackText;
    final hasText = text != null && text.isNotEmpty;

    Color? finalBgColor = backgroundColor;
    if (finalBgColor == null) {
      if (colorize && hasText) {
        finalBgColor = _getStringColor(name ?? text);
      } else {
        finalBgColor = hasText
            ? theme.colorScheme.primary.withValues(alpha: isDark ? 0.18 : 0.10)
            : (isDark ? const Color(0xFF24242A) : const Color(0xFFF2F2F7));
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

  Widget _buildFallbackContent(ThemeData theme) {
    final text = _effectiveFallbackText;
    if (text != null && text.isNotEmpty) {
      return _buildTextFallback(theme, text);
    }
    return _buildIconFallback(theme);
  }

  Widget _buildTextFallback(ThemeData theme, String text) {
    return Center(
      child: Text(
        text,
        style:
            textStyle ??
            TextStyle(
              fontSize: _fontSize,
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

  Widget _buildIconFallback(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final defaultColor = isDark
        ? const Color(0xFF8E8E93)
        : const Color(0xFFA1A1A6);

    return Center(
      child: Icon(
        shape == BoxShape.circle ? Icons.person_rounded : Icons.image_outlined,
        size: _iconSize,
        color: colorize && backgroundColor == null
            ? Colors.white
            : defaultColor,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Badge Helpers
  // ---------------------------------------------------------------------------

  bool get _hasBadge =>
      showBadge ||
      badgeText != null ||
      badgeCount != null ||
      customBadge != null;

  Widget _buildBadge(ThemeData theme) {
    if (customBadge != null) return customBadge!;

    final size = badgeSize ?? 16.0;
    final color = badgeColor ?? theme.colorScheme.error;
    String? contentStr;

    if (badgeText != null) {
      contentStr = badgeText;
    } else if (badgeCount != null) {
      contentStr = badgeCount! > badgeLimit
          ? '$badgeLimit+'
          : badgeCount.toString();
    }

    // Determine badge positioning offset (shift out of bounds slightly)
    final offset = size * 0.3;

    return Transform.translate(
      offset: Offset(
        badgeAlignment.x > 0 ? offset : (badgeAlignment.x < 0 ? -offset : 0),
        badgeAlignment.y > 0 ? offset : (badgeAlignment.y < 0 ? -offset : 0),
      ),
      child: Container(
        padding: contentStr != null
            ? EdgeInsets.symmetric(horizontal: size * 0.3)
            : null,
        constraints: BoxConstraints(minWidth: size, minHeight: size),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size),
          border: Border.all(color: theme.scaffoldBackgroundColor, width: 1.5),
        ),
        alignment: Alignment.center,
        child: contentStr != null
            ? Text(
                contentStr,
                style:
                    badgeTextStyle ??
                    TextStyle(
                      color: Colors.white,
                      fontSize: size * 0.65,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                textAlign: TextAlign.center,
              )
            : null,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Colorization Logic (HSL hash equivalent)
  // ---------------------------------------------------------------------------

  Color _getStringColor(String text) {
    if (text.isEmpty) return Colors.grey;
    int hash = 0;
    for (int i = 0; i < text.length; i++) {
      hash = text.codeUnitAt(i) + ((hash << 5) - hash);
      // Keep it 32-bit
      hash = hash & 0xFFFFFFFF;
    }

    // Convert to HSL(hash % 360, 75%, 50%) -> RGB
    final hue = (hash.abs() % 360).toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.75, 0.50).toColor();
  }

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
