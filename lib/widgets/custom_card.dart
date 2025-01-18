// lib/widgets/custom_card.dart
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double elevation;
  final BorderRadius? borderRadius;

  const CustomCard({
    Key? key,
    required this.child,
    this.onTap,
    this.padding,
    this.color,
    this.elevation = 2,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
      ),
      color: color ?? Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}