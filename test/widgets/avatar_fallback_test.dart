import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cache_avatar/src/widgets/avatar_fallback.dart';

void main() {
  group('AvatarFallback', () {
    testWidgets('renders fallback initials text when text is provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AvatarFallback(
              fallbackText: 'VH',
              fontSize: 16.0,
              iconSize: 20.0,
            ),
          ),
        ),
      );

      expect(find.text('VH'), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('renders person icon for circular avatar when text is absent', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AvatarFallback(
              fallbackText: null,
              shape: BoxShape.circle,
              fontSize: 16.0,
              iconSize: 24.0,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
    });

    testWidgets('renders image icon for rectangular avatar when text is absent', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AvatarFallback(
              fallbackText: null,
              shape: BoxShape.rectangle,
              fontSize: 16.0,
              iconSize: 24.0,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    });
  });
}
