import 'package:chick_game_prototype/app_layout/back_btn_layout.dart';
import 'package:chick_game_prototype/app_layout/chick_layout.dart';
import 'package:chick_game_prototype/screens/start_game_screen.dart';
import 'package:chick_game_prototype/widgets/flame_panel.dart';
import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  Future<bool> _handleBack(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const StartGameScreen()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    const termsText = '''
ПОГОДЖУЮЧИСЬ З ГРОЮ ТИ:

• Підтверджуєш, що цей застосунок створено виключно для розваги.
• Зберігаєш облікові дані й прогрес на власному пристрої; ми не збираємо конфіденційних даних.
• Надаєш дозвіл на показ внутрішнього контенту (рівні, екрани прогресу, магазин).
• Усвідомлюєш, що монети, які ти заробляєш, не мають реальної цінності поза грою.
• Обіцяєш грати чесно та не використовувати сторонні інструменти для маніпуляцій.

Якщо не погоджуєшся з умовами — просто видали застосунок і не продовжуй гру.''';

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
                    title: 'TERMS OF USE',
                    child: SingleChildScrollView(
                      child: Text(
                        termsText,
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
