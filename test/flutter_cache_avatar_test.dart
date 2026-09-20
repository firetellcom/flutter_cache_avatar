import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cache_avatar/flutter_cache_avatar.dart';

void main() {
  test('adds one to input values', () {
    // Basic instantiation test
    final avatar = CachedAvatar(imageUrl: 'https://example.com/image.png');
    expect(avatar.imageUrl, 'https://example.com/image.png');
  });

  testWidgets('CachedAvatar badge has proper compact size and does not expand to full avatar size', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CachedAvatar.avatar(
            name: 'John Doe',
            size: 80.0,
            showBadge: true,
            badgeCount: 5,
          ),
        ),
      ),
    );

    // Find the text '5' inside the badge
    final badgeTextFinder = find.text('5');
    expect(badgeTextFinder, findsOneWidget);

    // Find the badge Container (parent of the Center wrapping Text('5'))
    final containerFinder = find.ancestor(
      of: badgeTextFinder,
      matching: find.byType(Container),
    );
    expect(containerFinder, findsWidgets);

    // Verify the size of the badge container
    final badgeSize = tester.getSize(containerFinder.first);
    // Avatar is 80x80, the badge should be nicely balanced (~28px), NOT 80x80!
    expect(badgeSize.width, lessThan(36.0));
    expect(badgeSize.height, lessThan(36.0));
    expect(badgeSize.width, greaterThan(24.0));
    expect(badgeSize.height, greaterThan(24.0));
  });
}
