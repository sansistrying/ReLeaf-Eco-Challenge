import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/reward_card.dart';
import '../models/reward.dart';
import 'package:logging/logging.dart';

class RewardsScreen extends StatelessWidget {
  final Logger _logger = Logger('RewardsScreen');

  RewardsScreen({Key? key}) : super(key: key);

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
              title: Text('Rewards', style: Theme.of(context).textTheme.headlineSmall),
              background: Image.asset(
                'assets/images/rewards_background.jpg',
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
                  _buildPointsInfo(context),
                  const SizedBox(height: 24),
                  Text(
                    'Available Rewards',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ).animate().fadeIn().slideX(),
                  const SizedBox(height: 16),
                  _buildRewards(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsInfo(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Points',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '1,500',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Implement points history
                _logger.info('Viewing points history');
                // Navigate to a points history screen or show a dialog
              },
              child: const Text('View History'),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildRewards() {
    final List<Reward> rewards = [
      Reward(
        id: '1',
        title: 'Eco-friendly Water Bottle',
        description: 'Reusable water bottle made from recycled materials',
        points: 500,
        image: 'assets/images/water_bottle.jpg',
      ),
      Reward(
        id: '2',
        title: 'Organic Cotton T-shirt',
        description: 'Comfortable t-shirt made from 100% organic cotton',
        points: 750,
        image: 'assets/images/tshirt.jpg',
      ),
      Reward(
        id: '3',
        title: 'Solar Power Bank',
        description: 'Charge your devices on the go with solar energy',
        points: 1000,
        image: 'assets/images/power_bank.jpg',
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        return RewardCard(reward: rewards[index])
            .animate()
            .fadeIn(delay: (100 * index).milliseconds)
            .slideX();
      },
    );
  }
}

