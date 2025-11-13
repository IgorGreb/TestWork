import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressBarWithPercent extends StatelessWidget {
  final double progress;

  const ProgressBarWithPercent({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    const double height = 40.0;
    const BorderRadius borderRadius = BorderRadius.all(Radius.circular(15.0));
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          final double filledWidth =
              (progress.clamp(0.0, 1.0)) * (maxWidth - 4);

          return Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFff3b3b),
                  Color(0xFFff8a00),
                  Color(0xFFffeb00),
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
                      duration: const Duration(milliseconds: 1000),
                      width: filledWidth,
                      height: height,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFff3b3b),
                            Color(0xFFff8a00),
                            Color(0xFFffeb00),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                    ),

                    SizedBox(
                      width: maxWidth - 4,
                      height: height,
                      child: Center(
                        child: Stack(
                          children: [
                            // Контур тексту (бордер)
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: GoogleFonts.rubikMonoOne(
                                textStyle: TextStyle(
                                  fontSize: screenWidth * 0.03, // адаптивно
                                  fontWeight: FontWeight.bold,
                                  foreground:
                                      Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 3
                                        ..color = Color(0xFF7A025A),
                                ),
                              ),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: GoogleFonts.rubikMonoOne(
                                textStyle: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
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
