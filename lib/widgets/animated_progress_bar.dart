// lib/widgets/animated_progress_bar.dart
import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final Color backgroundColor;
  final Color foregroundColor;
  final double height;
  final Duration duration;

  const AnimatedProgressBar({
    Key? key,
    required this.progress,
    required this.backgroundColor,
    required this.foregroundColor,
    this.height = 8.0,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Stack(
        children: [
          TweenAnimationBuilder<double>(
            duration: duration,
            curve: Curves.easeInOut,
            tween: Tween<double>(
              begin: 0,
              end: progress.clamp(0.0, 1.0),
            ),
            builder: (context, value, _) => FractionallySizedBox(
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  color: foregroundColor,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

