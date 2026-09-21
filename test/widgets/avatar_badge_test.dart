import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cache_avatar/src/widgets/avatar_badge.dart';

void main() {
  group('AvatarBadge', () {
    test('shouldRender logic checks all badge triggers', () {
      expect(AvatarBadge.shouldRender(), isFalse);
      expect(AvatarBadge.shouldRender(showBadge: true), isTrue);
      expect(AvatarBadge.shouldRender(badgeText: 'NEW'), isTrue);
      expect(AvatarBadge.shouldRender(badgeCount: 3), isTrue);
      expect(
        AvatarBadge.shouldRender(customBadge: const SizedBox()),
        isTrue,
      );
    });

    testWidgets('renders numeric count text inside badge', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AvatarBadge(
              badgeCount: 5,
              minDimension: 60.0,
            ),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('formats badge limit with plus sign when exceeded', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AvatarBadge(
              badgeCount: 150,
              badgeLimit: 99,
              minDimension: 60.0,
            ),
          ),
        ),
      );

      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('renders custom badge widget directly when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AvatarBadge(
              customBadge: Icon(Icons.star, key: Key('custom_star')),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('custom_star')), findsOneWidget);
    });

    testWidgets('renders status dot when count or text is not given', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AvatarBadge(
              minDimension: 40.0,
            ),
          ),
        ),
      );

      // Should render a circular container without any Text
      expect(find.byType(Text), findsNothing);
      expect(find.byType(Container), findsWidgets);
    });
  });
}
