// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class LitleBtnLayout extends StatelessWidget {
  final Function()? onPressed;
  final double width;
  final double height;
  final bool or;

  const LitleBtnLayout({
    super.key,
    this.onPressed,
    required this.width,
    required this.height,
    required this.or,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        width: width,
        height: height,
        child:
            or == true
                ? Image.asset('assets/menu.png')
                : Image.asset('assets/info.png'),
      ),
    );
  }
}
