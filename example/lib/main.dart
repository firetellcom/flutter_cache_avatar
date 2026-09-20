import 'package:flutter/material.dart';
import 'package:flutter_cache_avatar/flutter_cache_avatar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cached Avatar Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Cache Avatar Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Avatar with Badge'),
            const SizedBox(height: 10),
            const CachedAvatar(
              name: 'John Doe',
              size: 80.0,
              colorize: true,
              showBadge: true,
              badgeCount: 5,
            ),
            const SizedBox(height: 30),
            const Text('Initials Fallback (Default size 40px)'),
            const SizedBox(height: 10),
            const CachedAvatar(name: 'Jane Smith', colorize: true),
            const SizedBox(height: 30),
            const Text('Rounded Avatar'),
            const SizedBox(height: 10),
            const CachedAvatar.rounded(
              name: 'Flutter Team',
              size: 60.0,
              radius: 16.0,
              colorize: true,
            ),
          ],
        ),
      ),
    );
  }
}
