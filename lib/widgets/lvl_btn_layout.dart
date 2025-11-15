import 'package:flutter/material.dart';

class LevelsBtnLayout extends StatelessWidget {
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final String imagePath;
  final bool locked;
  final bool completed;
  final String label;

  const LevelsBtnLayout({
    super.key,
    this.onPressed,
    required this.width,
    required this.height,
    required this.imagePath,
    this.locked = false,
    this.completed = false,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: locked ? null : onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.transparent,
        splashFactory: locked ? NoSplash.splashFactory : null,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ColorFiltered(
                colorFilter: locked
                    ? const ColorFilter.mode(
                      Colors.black54,
                      BlendMode.srcATop,
                    )
                    : const ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.dst,
                    ),
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (locked)
              const Align(
                alignment: Alignment.center,
                child: Icon(Icons.lock, color: Colors.white70),
              ),
            if (!locked && completed)
              const Positioned(
                top: 6,
                right: 6,
                child: Icon(Icons.star, color: Colors.yellowAccent),
              ),
          ],
        ),
      ),
    );
  }
}
