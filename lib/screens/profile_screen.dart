import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/achievement_card.dart';
import '../models/achievement.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('John Doe', style: Theme.of(context).textTheme.headlineSmall),
              background: Image.asset(
                'assets/images/profile_background.jpg',
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
                  _buildProfileInfo(context),
                  const SizedBox(height: 24),
                  Text(
                    'Achievements',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ).animate().fadeIn().slideX(),
                  const SizedBox(height: 16),
                  _buildAchievements(),
                  const SizedBox(height: 24),
                  Text(
                    'Statistics',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ).animate().fadeIn().slideX(),
                  const SizedBox(height: 16),
                  _buildStatistics(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/images/profile_picture.jpg'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John Doe',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'Eco Warrior',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Joined: January 2023',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn().scale();
  }

  Widget _buildAchievements() {
    final List<Achievement> achievements = [
      Achievement(
        id: '1',
        title: 'Tree Hugger',
        description: 'Planted 10 trees',
        icon: Icons.nature,
      ),
      Achievement(
        id: '2',
        title: 'Waste Warrior',
        description: 'Recycled 100 kg of waste',
        icon: Icons.delete_outline,
      ),
      Achievement(
        id: '3',
        title: 'Energy Saver',
        description: 'Reduced energy consumption by 20%',
        icon: Icons.bolt,
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        return AchievementCard(achievement: achievements[index])
            .animate()
            .fadeIn(delay: (100 * index).milliseconds)
            .slideX();
      },
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return Column(
      children: [
        _buildStatCard(context, 'Total Points', '1,500'),
        _buildStatCard(context, 'Actions Completed', '75'),
        _buildStatCard(context, 'CO2 Saved', '500 kg'),
      ],
    ).animate().fadeIn().scale();
  }

  Widget _buildStatCard(BuildContext context, String label, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

