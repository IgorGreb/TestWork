import 'package:chick_game_prototype/features/shop/shop_controller.dart';
import 'package:chick_game_prototype/widgets/lvl_btn_layout.dart';
import 'package:chick_game_prototype/app_layout/back_btn_layout.dart';
import 'package:chick_game_prototype/app_layout/chick_layout.dart';
import 'package:chick_game_prototype/app_layout/score_layout.dart';
import 'package:chick_game_prototype/core/constants/custom_colors.dart';
import 'package:chick_game_prototype/features/levels/level_missions.dart';
import 'package:chick_game_prototype/features/levels/levels_controller.dart';
import 'package:chick_game_prototype/screens/start_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LevelsScreen extends ConsumerWidget {
  const LevelsScreen({super.key});

  final int totalLevelsToShow = 9; // відображаємо тільки перші 9 рівнів
  final int totalImages = 9;
  // кількість різних картинок

  Future<bool> _handleBackNavigation(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => const StartGameScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: Curves.easeInOut));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelsState = ref.watch(levelsControllerProvider);
    final shopState = ref.watch(shopControllerProvider);

    final currentMission = missionForLevel(
      levelsState.unlockedCount.clamp(1, totalLevelsToShow),
    );
    return WillPopScope(
      onWillPop: () => _handleBackNavigation(context),
      child: ChickLayout(
        chickShow: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackBtnLayout(
                    onPressed: () => _handleBackNavigation(context),
                  ),
                  ScoreLayout(width: 0, height: 60, score: shopState.coins),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'CHANGE LEVEL',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: GoogleFonts.rubikMonoOne().fontFamily,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: CustomColors.pink, width: 2),
                    borderRadius: BorderRadius.circular(18),
                    image: const DecorationImage(
                      image: AssetImage('assets/info_webp/Rectangle 7.webp'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: totalLevelsToShow,
                    itemBuilder: (context, index) {
                      final levelNumber = index + 1;
                      final imageIndex = (index % totalImages) + 1;
                      final imagePath =
                          'assets/lvls_webp/level_$imageIndex.webp';
                      final isUnlocked =
                          levelNumber <= levelsState.unlockedCount;
                      final completed = ref
                          .read(levelsControllerProvider.notifier)
                          .isLevelCompleted(levelNumber);

                      return LevelsBtnLayout(
                        width: 100,
                        height: 100,
                        imagePath: imagePath,
                        locked: !isUnlocked,
                        completed: completed,

                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/game',
                            arguments: levelNumber,
                          );
                        },
                        label: '',
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Mission ${currentMission.level}: ${currentMission.description}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
