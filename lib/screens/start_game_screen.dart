import 'package:chick_game_prototype/widgets/start_btn_widget.dart';
import 'package:chick_game_prototype/app_layout/chick_layout.dart';
import 'package:chick_game_prototype/app_layout/litle_btn_layout.dart';
import 'package:flutter/material.dart';

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({super.key});

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  @override
  Widget build(BuildContext context) {
    return ChickLayout(
      chickShow: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LitleBtnLayout(
                  onPressed: () {
                    Navigator.pushNamed(context, '/howtoplay');
                  },
                  or: false,
                ),
                LitleBtnLayout(
                  onPressed: () {
                    Navigator.pushNamed(context, '/menu');
                  },
                  or: true,
                ),
              ],
            ),
          ),
          const Spacer(),
          const StartBtnWidget(label: 'PLAY'),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
