// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class LitleBtnLayout extends StatelessWidget {
  final Function()? onPressed;

  final bool or;

  const LitleBtnLayout({super.key, this.onPressed, required this.or});

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
        child:
            or == true
                ? Image.asset('assets/btn_webp/menu.webp')
                : Image.asset('assets/btn_webp/info.webp'),
      ),
    );
  }
}
