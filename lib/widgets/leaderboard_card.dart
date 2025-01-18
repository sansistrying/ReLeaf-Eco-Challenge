import 'package:flutter/material.dart';
import '../models/user.dart';

class LeaderboardCard extends StatelessWidget {
  final List<User> topUsers;

  const LeaderboardCard({Key? key, required this.topUsers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (int i = 0; i < topUsers.length; i++)
              _buildUserRow(context, topUsers[i], i + 1),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRow(BuildContext context, User user, int rank) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$rank.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundImage: AssetImage(user.avatar),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              user.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Text(
            '${user.points} pts',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

