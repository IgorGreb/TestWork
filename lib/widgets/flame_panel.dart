import 'package:flutter/material.dart';

class FlamePanel extends StatelessWidget {
  const FlamePanel({
    super.key,
    required this.title,
    required this.child,
    this.titleSpacing = 20,
  });

  final String title;
  final Widget child;
  final double titleSpacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: Colors.pinkAccent, width: 3),
        gradient: const LinearGradient(
          colors: [Color(0xFF6B1A75), Color(0xFF300849)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            offset: const Offset(0, 12),
            blurRadius: 32,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
          SizedBox(height: titleSpacing),
          Expanded(child: child),
        ],
      ),
    );
  }
}
