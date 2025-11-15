import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final double heightSize = screenHeight * 0.091;

    final double fontSize = screenWidth * 0.04;

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
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.rubikMonoOne(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  height: 1.0,
                  shadows: const [
                    Shadow(
                      offset: Offset(1, 2),
                      color: Colors.black26,
                      blurRadius: 3,
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
