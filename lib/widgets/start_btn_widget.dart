import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartBtnWidget extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double widthFactor;
  final double heightFactor;
  final double fontFactor;

  const StartBtnWidget({
    super.key,
    required this.label,
    this.onPressed,
    this.widthFactor = 0.68,
    this.heightFactor = 0.18,
    this.fontFactor = 0.14,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double widthSize = screenWidth * widthFactor;
    final double heightSize = screenHeight * heightFactor;
    final double fontSize = screenWidth * fontFactor;

    return Center(
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          minimumSize: MaterialStateProperty.all(Size.zero),
        ),
        onPressed:
            onPressed ??
            () {
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
                  letterSpacing: 1.5,
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
