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
            CachedAvatar.avatar(
              name: 'John Doe',
              size: 80.0,
              colorize: true,
              showBadge: true,
              badgeCount: 5,
            ),
            const SizedBox(height: 30),
            const Text('Initials Fallback'),
            const SizedBox(height: 10),
            CachedAvatar.avatar(name: 'Jane Smith', size: 80.0, colorize: true),
          ],
        ),
      ),
    );
  }
}
