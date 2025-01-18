// lib/widgets/eco_action_card.dart
import 'package:flutter/material.dart';
import '../models/eco_action.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EcoActionCard extends StatelessWidget {
  final EcoAction action;
  final VoidCallback? onTap;
  final bool isCompleted;
  final double progress;

  const EcoActionCard({
    Key? key,
    required this.action,
    this.onTap,
    this.isCompleted = false,
    this.progress = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildActionIcon(context),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          action.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          action.description,
                          style: theme.textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildActionDetails(context),
              if (progress > 0) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate()
      .fadeIn()
      .slideX(begin: 0.2, duration: const Duration(milliseconds: 500));
  }

  Widget _buildActionIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        action.icon,
        color: Theme.of(context).colorScheme.primary,
        size: 24,
      ),
    );
  }

  Widget _buildActionDetails(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.star,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              '${action.points} points',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.eco,
              size: 16,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 4),
            Text(
              '${action.carbonOffset}kg CO₂',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (isCompleted)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Colors.green,
                ),
                SizedBox(width: 4),
                Text(
                  'Completed',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

