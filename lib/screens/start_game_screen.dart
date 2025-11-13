import 'package:chick_game_prototype/%C2%A0widgets/start_btn_widget.dart';
import 'package:chick_game_prototype/app_layout/litle_btn_layout.dart';
import 'package:chick_game_prototype/app_layout/chick_layout.dart';
import 'package:flutter/material.dart';

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({super.key});

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChickLayout(
        chickShow: 2,
        child: Column(
          children: [
            // Ряд кнопок по краях
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LitleBtnLayout(
                    onPressed: () {},
                    width: 50,
                    height: 50,
                    or: false,
                  ),
                  LitleBtnLayout(
                    onPressed: () {},
                    width: 50,
                    height: 50,
                    or: true,
                  ),
                ],
              ),
            ),

            Spacer(), // пушить кнопку вниз
            StartBtnWidget(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
