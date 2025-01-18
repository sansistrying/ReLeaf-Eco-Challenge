import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String label;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

