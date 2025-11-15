import 'package:chick_game_prototype/app_layout/back_btn_layout.dart';
import 'package:chick_game_prototype/app_layout/chick_layout.dart';
import 'package:chick_game_prototype/core/constants/custom_colors.dart';
import 'package:chick_game_prototype/screens/start_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _handleBackNavigation(context),
      child: ChickLayout(
        chickShow: 0,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 25,
                  ),
                  child: BackBtnLayout(
                    onPressed: () => _handleBackNavigation(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              height: 500,
              width: 350,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CustomColors.some.withOpacity(0.5),
                border: Border.all(color: CustomColors.pink, width: 2),
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/info_webp/Rectangle 7.webp'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'HOW TO PLAY',
                        style: GoogleFonts.rubikMonoOne(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: SingleChildScrollView(
                        child: Text(
                          'Tap left/right to move the chick, catch glowing eggs and avoid bad ones.',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.rubikMonoOne().fontFamily,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
