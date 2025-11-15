import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldLayout extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onEditTap;
  final String text;
  final double? width;

  const TextFieldLayout({
    super.key,
    required this.controller,
    this.onEditTap,
    required this.text,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double resolvedWidth =
        width ?? screenWidth * 0.85; // адаптивна ширина, але можна задавати

    return Container(
      width: resolvedWidth,
      height: 60, // фіксована висота
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFF65D0), // рожевий із прикладу
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // TEXT FIELD
          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.rubikMonoOne(
                color: Colors.white,
                fontSize: 20,
              ),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: text,
                hintStyle: GoogleFonts.rubikMonoOne(
                  color: Colors.white70,
                  fontSize: 18,
                ),
                border: InputBorder.none, // без рамки
                isCollapsed: true,
                contentPadding: const EdgeInsets.only(bottom: 4),
              ),
            ),
          ),

          // EDIT ICON
          GestureDetector(
            onTap: onEditTap,
            child: const Icon(
              Icons.edit_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
