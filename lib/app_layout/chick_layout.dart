import 'package:chick_game_prototype/%C2%A0widgets/progress_bar.dart';
import 'package:flutter/material.dart';

class ChickLayout extends StatelessWidget {
  final Widget? child;
  final bool showProgressBar;
  final double progress;
  final int chickShow;

  const ChickLayout({
    super.key,
    this.child,
    this.showProgressBar = false,
    this.progress = 0,
    required this.chickShow,
  });

  @override
  Widget build(BuildContext context) {
    Widget chickImage;

    // 🔁 Вибір картинки за допомогою switch
    switch (chickShow) {
      case 1:
        chickImage = Image.asset(
          'assets/chick.png',
          width: MediaQuery.of(context).size.width * 0.8,
        );
        break;
      case 2:
        chickImage = Image.asset(
          'assets/little_chick.png',
          width: MediaQuery.of(context).size.width * 0.71,
        );
        break;
      default:
        chickImage = const SizedBox(); // якщо нічого не треба показувати
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Фон
          Image.asset('assets/loading_bg.png', fit: BoxFit.fill),

          // Курка (залежно від switch-case)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25.0, left: 40),
              child: chickImage,
            ),
          ),

          // Основний контент поверх курки
          if (child != null) child!,

          // Прогрес бар
          if (showProgressBar)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: ProgressBarWithPercent(progress: progress),
              ),
            ),
        ],
      ),
    );
  }
}
