import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/eco_action_card.dart';
import '../widgets/leaderboard_card.dart';
import '../models/eco_action.dart';
import '../models/user.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('ReLeaf', style: Theme.of(context).textTheme.headlineMedium),
                background: Image.asset(
                  'assets/images/nature_background.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Impact',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ).animate().fadeIn().slideX(),
                    const SizedBox(height: 16),
                    _buildImpactStats(context),
                    const SizedBox(height: 24),
                    Text(
                      'Today\'s Eco Actions',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ).animate().fadeIn().slideX(),
                    const SizedBox(height: 16),
                    _buildEcoActions(),
                    const SizedBox(height: 24),
                    Text(
                      'Leaderboard',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ).animate().fadeIn().slideX(),
                    const SizedBox(height: 16),
                    _buildLeaderboard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard(context, '2,500', 'Carbon Offset (kg)'),
        _buildStatCard(context, '150', 'Trees Planted'),
        _buildStatCard(context, '500', 'Points Earned'),
      ],
    ).animate().fadeIn().scale();
  }

  Widget _buildStatCard(BuildContext context, String value, String label) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEcoActions() {
    final List<EcoAction> actions = [
      EcoAction(
        id: '1',
        title: 'Plant a Tree',
        description: 'Plant a tree in your local community',
        points: 100,
        icon: Icons.nature,
      ),
      EcoAction(
        id: '2',
        title: 'Recycle Electronics',
        description: 'Properly dispose of old electronics',
        points: 50,
        icon: Icons.phone_android,
      ),
      EcoAction(
        id: '3',
        title: 'Use Public Transport',
        description: 'Commute using public transportation',
        points: 30,
        icon: Icons.directions_bus,
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return EcoActionCard(action: actions[index])
            .animate()
            .fadeIn(delay: (100 * index).milliseconds)
            .slideX();
      },
    );
  }

  Widget _buildLeaderboard() {
    final List<User> topUsers = [
      User(id: '1', name: 'Alice', points: 1200, avatar: 'assets/images/avatar1.png'),
      User(id: '2', name: 'Bob', points: 1100, avatar: 'assets/images/avatar2.png'),
      User(id: '3', name: 'Charlie', points: 1000, avatar: 'assets/images/avatar3.png'),
    ];

    return LeaderboardCard(topUsers: topUsers).animate().fadeIn().scale();
  }
}

