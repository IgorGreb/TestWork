import 'package:flutter/material.dart';

class ProfileIconBtnLayout extends StatelessWidget {
  final Function()? onPressed;

  const ProfileIconBtnLayout({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      onPressed: onPressed,
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          children: [
            Image.asset('assets/profile_webp/profile.webp'),
            Padding(
              padding: const EdgeInsets.only(top: 125.0),
              child: Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/profile_webp/Frame.webp'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
