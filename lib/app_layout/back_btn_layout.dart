import 'package:flutter/material.dart';

class BackBtnLayout extends StatelessWidget {
  final Function()? onPressed;

  const BackBtnLayout({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      onPressed: onPressed,
      child: SizedBox(
        width: 80,
        height: 80,
        child: Image.asset('assets/btn_webp/back.webp'),
      ),
    );
  }
}
