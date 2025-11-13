import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartBtnWidget extends StatelessWidget {
  const StartBtnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Отримуємо розміри екрану
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Задаємо адаптивні розміри кнопки
    final double widthSize = screenWidth * 0.60; // 60% ширини екрану
    final double heightSize = screenHeight * 0.20; // 8% висоти екрану

    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/levels');
      },
      child: Container(
        width: widthSize,
        height: heightSize,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/start_btn.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Text(
            'PLAY',
            style: GoogleFonts.rubikMonoOne(
              textStyle: TextStyle(color: Colors.white, fontSize: 50),
            ),
          ),
        ),
      ),
    );
  }
}
