// lib/widgets/stats_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isWide;
  final VoidCallback? onTap;

  const StatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isWide = false,
    this.onTap,
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 24,
                    ),
                  ),
                  if (isWide) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ],
              ),
              if (!isWide) ...[
                const SizedBox(height: 12),
                Text(
                  title,
                  style: theme.textTheme.titleMedium,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              if (isWide)
                LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
            ],
          ),
        ),
      ),
    ).animate()
      .fadeIn()
      .scale(delay: const Duration(milliseconds: 300));
  }
}