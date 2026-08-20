import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cache_avatar/flutter_cache_avatar.dart';

void main() {
  test('adds one to input values', () {
    // Basic instantiation test
    final avatar = CachedAvatar(imageUrl: 'https://example.com/image.png');
    expect(avatar.imageUrl, 'https://example.com/image.png');
  });
}
