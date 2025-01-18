import 'package:flutter/material.dart';
import '../models/eco_action.dart';
import 'package:logging/logging.dart';

class EcoActionCard extends StatelessWidget {
  final EcoAction action;
  final Logger _logger = Logger('EcoActionCard');

  EcoActionCard({Key? key, required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // Implement action details or completion logic
          _logger.info('Eco action tapped: ${action.title}');
          // Navigate to action details screen or show a completion dialog
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  action.icon,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      action.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                '+${action.points}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

