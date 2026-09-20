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

  testWidgets('CachedAvatar direct constructor defaults to circle with default size 40.0', (tester) async {
    const avatar = CachedAvatar(name: 'Jane Doe');
    expect(avatar.shape, BoxShape.circle);
    expect(avatar.width, 40.0);
    expect(avatar.height, 40.0);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: avatar,
        ),
      ),
    );

    expect(find.text('JD'), findsOneWidget);
  });

  testWidgets('CachedAvatar.rounded creates rectangular shape with borderRadius', (tester) async {
    const avatar = CachedAvatar.rounded(name: 'Flutter Team', size: 60.0, radius: 16.0);
    expect(avatar.shape, BoxShape.rectangle);
    expect(avatar.width, 60.0);
    expect(avatar.height, 60.0);
    expect(avatar.radius, 16.0);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: avatar,
        ),
      ),
    );

    expect(find.text('FT'), findsOneWidget);
  });
}
