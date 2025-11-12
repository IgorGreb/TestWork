import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/levels'),
              child: const Text('Play'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              child: const Text('Profile'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: const Text('Settings'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/leaderboard'),
              child: const Text('Leaderboard'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/shop'),
              child: const Text('Shop'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/howtoplay'),
              child: const Text('How to Play'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}
