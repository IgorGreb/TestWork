import 'package:flutter/material.dart';

class MenuBtnLayout extends StatelessWidget {
  final String btnText;
  final String routeName;
  final Future<void> Function()? onTapOverride;

  const MenuBtnLayout({
    super.key,
    required this.btnText,
    required this.routeName,
    this.onTapOverride,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double widthSize = screenWidth * 0.7;
    final double heightSize = screenHeight * 0.11;
    double fontSize = screenWidth * 0.05;

    // Якщо текст довший, поступово зменшуємо шрифт
    if (btnText.length > 12) {
      fontSize *= 0.85;
    }
    if (btnText.length > 18) {
      fontSize *= 0.75;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.012),
      child: SizedBox(
        width: widthSize,
        height: heightSize,
        child: TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
          ),
          onPressed:
              onTapOverride ??
              () {
                if (routeName.isNotEmpty) {
                  Navigator.pushNamed(context, routeName);
                }
              },
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/btn_webp/start_btn.webp'),
                fit: BoxFit.contain,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              btnText,
              textAlign: TextAlign.center,
              maxLines: 2,
              softWrap: true,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
