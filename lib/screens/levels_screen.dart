import 'package:chick_game_prototype/app_layout/chick_layout.dart';
import 'package:flutter/material.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: ChickLayout(chickShow: 0)));
  }
}
