import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    // _simulateLoading();
  }

  void _simulateLoading() {
    const duration = Duration(seconds: 5);
    const tick = Duration(milliseconds: 50);
    int totalTicks = duration.inMilliseconds ~/ tick.inMilliseconds;
    double increment = 1 / totalTicks;

    Future.doWhile(() async {
      await Future.delayed(tick);
      setState(() {
        progress += increment;
        if (progress > 1) progress = 1;
      });
      return progress < 1;
    }).then((_) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/menu');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/loading_bg.png',
              ), // 🔹 твій шлях до зображення
              fit: BoxFit.cover, // заповнює весь екран
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
