import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartBtnWidget extends StatelessWidget {
  final String label;

  const StartBtnWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Адаптивні розміри кнопки
    final double widthSize = screenWidth * 0.68; // 68% ширини
    final double heightSize = screenHeight * 0.18; // 18% висоти

    // Адаптивний розмір тексту
    final double fontSize = screenWidth * 0.14; // ~14% ширини екрана

    return Center(
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          minimumSize: MaterialStateProperty.all(
            Size.zero,
          ), // щоб не було зайвого мін. розміру
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/levels');
        },
        child: Container(
          width: widthSize,
          height: heightSize,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/btn_webp/start_btn.webp'),
              fit: BoxFit.contain,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.rubikMonoOne(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  height: 1.0,
                  shadows: const [
                    Shadow(
                      offset: Offset(2, 3),
                      color: Colors.black26,
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
