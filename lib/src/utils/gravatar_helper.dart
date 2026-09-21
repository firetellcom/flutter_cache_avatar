import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Helper utility for generating Gravatar profile image URLs.
abstract final class GravatarHelper {
  /// Generates a Gravatar URL for the given [email] and optional [size].
  ///
  /// - Lowercases and trims the email address before computing the MD5 hash.
  /// - Sets `d=404` so non-existent Gravatars fail cleanly, triggering fallbacks.
  /// - Returns `null` if [email] is null, empty, or consists solely of whitespace.
  static String? resolveUrl(String? email, {int size = 50}) {
    if (email == null) return null;
    final trimmed = email.trim();
    if (trimmed.isEmpty) return null;

    final emailHash = md5
        .convert(utf8.encode(trimmed.toLowerCase()))
        .toString();
    return 'https://www.gravatar.com/avatar/$emailHash?s=$size&d=404';
  }
}
