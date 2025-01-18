// lib/widgets/empty_state.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final String? lottieAsset;
  final IconData? icon;
  final VoidCallback? onActionPressed;
  final String? actionText;

  const EmptyState({
    Key? key,
    required this.title,
    required this.message,
    this.lottieAsset,
    this.icon,
    this.onActionPressed,
    this.actionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (lottieAsset != null)
              Lottie.asset(
                lottieAsset!,
                width: 200,
                height: 200,
              )
            else if (icon != null)
              Icon(
                icon,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onActionPressed != null && actionText != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onActionPressed,
                icon: const Icon(Icons.add),
                label: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

