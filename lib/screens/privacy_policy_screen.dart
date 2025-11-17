import 'package:chick_game_prototype/app_layout/back_btn_layout.dart';
import 'package:chick_game_prototype/app_layout/chick_layout.dart';
import 'package:chick_game_prototype/screens/start_game_screen.dart';
import 'package:chick_game_prototype/widgets/flame_panel.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  Future<bool> _handleBack(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const StartGameScreen()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    const privacyText = '''
Ми не збираємо персональні дані, окрім інформації, яку ти прямо вводиш у профілі (нікнейм та email). Дані зберігаються локально на пристрої через SharedPreferences.

Файли зображень, які ти завантажуєш як аватар, залишаються тільки на твоєму пристрої й не передаються третім сторонам.

Ми використовуємо аналітику лише для відстеження стабільності та продуктивності гри без ідентифікації користувача.

Вимкнення або видалення гри знищує всі локальні дані.''';

    return WillPopScope(
      onWillPop: () => _handleBack(context),
      child: ChickLayout(
        chickShow: 0,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: BackBtnLayout(onPressed: () => _handleBack(context)),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: FlamePanel(
                    title: 'PRIVACY POLICY',
                    child: SingleChildScrollView(
                      child: Text(
                        privacyText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
