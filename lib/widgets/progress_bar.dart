import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressBarWithPercent extends StatelessWidget {
  final double progress;

  const ProgressBarWithPercent({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double height = screenWidth * 0.08;
    final BorderRadius borderRadius = BorderRadius.circular(height * 0.4);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          final double filledWidth =
              (progress.clamp(0.0, 1.0)) * (maxWidth - 4);

          return Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF3B3B),
                  Color(0xFFFF8A00),
                  Color(0xFFFFEB00),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: borderRadius,
            ),
            padding: const EdgeInsets.all(2.0),
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: borderRadius,
              ),
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      width: filledWidth,
                      height: height,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFF3B3B),
                            Color(0xFFFF8A00),
                            Color(0xFFFFEB00),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),

                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: GoogleFonts.rubikMonoOne(
                              textStyle: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                foreground:
                                    Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 3
                                      ..color = const Color(0xFF7A025A),
                              ),
                            ),
                          ),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: GoogleFonts.rubikMonoOne(
                              textStyle: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
