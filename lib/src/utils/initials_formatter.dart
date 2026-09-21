/// Utility class to format user names into initials for avatar fallbacks.
abstract final class InitialsFormatter {
  /// Extracts uppercase initials from the provided [name].
  ///
  /// - Takes the first character of the first word.
  /// - If multiple words exist, appends the first character of the last word.
  /// - Returns `null` if [name] is null, empty, or consists solely of whitespace.
  static String? format(String? name) {
    if (name == null) return null;
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;

    final words = trimmed.split(RegExp(r'\s+'));
    if (words.isEmpty) return null;

    String initials = words.first[0];
    if (words.length > 1) {
      initials += words.last[0];
    }
    return initials.toUpperCase();
  }
}
