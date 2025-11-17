import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScoreLayout extends StatelessWidget {
  final double width;
  final double height;
  final int score;
  const ScoreLayout({
    super.key,
    required this.width,
    required this.height,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: height * 0.17),
          child: Container(
            width: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/score_webp/score1.webp'),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              score.toString(),
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.rubikMonoOne().fontFamily,
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 130),
          child: SizedBox(
            width: 50,
            child: Image.asset('assets/score_webp/score_coin.webp'),
          ),
        ),
      ],
    );
  }
}
