import 'package:chick_game_prototype/app_layout/back_btn_layout.dart';
import 'package:chick_game_prototype/app_layout/chick_layout.dart';
import 'package:chick_game_prototype/screens/start_game_screen.dart';
import 'package:chick_game_prototype/widgets/start_btn_widget.dart';
import 'package:flutter/material.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  Future<bool> _handleBackNavigation(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => const StartGameScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeInOut));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final steps = <_HowToPlayStep>[
      const _HowToPlayStep(
        title: 'МІНЯЙ ТА ЗБИРАЙ',
        description:
            'Торкнись двох сусідніх яєць, щоб поміняти їх місцями. Комбінації з трьох і більше або квадрат 2×2 очищують поле.',
      ),
      const _HowToPlayStep(
        title: 'ПЕРЕГАНЯЙ ЦІЛЬ',
        description:
            'Заповни шкалу очок до того, як закінчаться ходи чи час. Комбо приносять монети для магазину.',
      ),
      const _HowToPlayStep(
        title: 'КОРИСТУЙСЯ ПІДКАЗКАМИ',
        description:
            'Застряг на 5 секунд? Світла рамка покаже доступний хід — скористайся ним або знайди кращий.',
      ),
      const _HowToPlayStep(
        title: 'СТЕЖ ЗА ТАЙМЕРОМ',
        description:
            'Кожна місія має відлік. Утримуй дошку активною та виконуй цілі, поки таймер не згорів.',
      ),
    ];

    return WillPopScope(
      onWillPop: () => _handleBackNavigation(context),
      child: ChickLayout(
        chickShow: 0,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 20),
                  child: BackBtnLayout(
                    onPressed: () => _handleBackNavigation(context),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(color: Colors.pinkAccent, width: 3),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6B1A75), Color(0xFF4A0F59)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.45),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'HOW TO PLAY',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 28,
                                  letterSpacing: 2,
                                ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.separated(
                            itemCount: steps.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final step = steps[index];
                              return _HowToPlayTile(
                                index: index + 1,
                                step: step,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                StartBtnWidget(
                  label: 'ОК',
                  widthFactor: 0.5,
                  heightFactor: 0.12,
                  fontFactor: 0.08,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/menu');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HowToPlayStep {
  final String title;
  final String description;

  const _HowToPlayStep({required this.title, required this.description});
}

class _HowToPlayTile extends StatelessWidget {
  const _HowToPlayTile({required this.index, required this.step});
  final int index;
  final _HowToPlayStep step;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFF74C9).withOpacity(0.25),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC93C),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              index.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  step.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
