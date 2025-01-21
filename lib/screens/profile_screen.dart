// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/achievement_card.dart';
import '../models/achievement.dart';
import '../widgets/animated_progress_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: _buildProfileContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
  return SliverAppBar(
    floating: true,
    pinned: true,
    expandedHeight: 60,
    backgroundColor: Theme.of(context).colorScheme.primary,
    centerTitle: true,
    flexibleSpace: FlexibleSpaceBar(
      title: const Text(
        'Profile',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
    ),
    actions: [
      IconButton(
        icon: const Icon(
          Icons.settings,
          color: Colors.white,
        ),
        onPressed: () {
          // Implement settings
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
        onPressed: () {
          // Implement profile editing
        },
      ),
    ],
  );
}

  Widget _buildProfileContent(BuildContext context) {
    return Column(
      children: [
        _buildProfileHeader(context),
        const SizedBox(height: 16),
        _buildLevelProgress(context),
        const SizedBox(height: 24),
        _buildTabBar(context),
        _buildTabContent(context),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    if (_isLoading) {
      return _buildShimmerLoading();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 4,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile_picture.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ).animate().scale(),
          const SizedBox(height: 16),
          Text(
            'John Doe',
            style: Theme.of(context).textTheme.headlineSmall,
          ).animate().fadeIn(),
          const SizedBox(height: 4),
          Text(
            'Eco Warrior Level 5',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ).animate().fadeIn(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatItem(context, '1.5K', 'Points'),
              _buildStatDivider(),
              _buildStatItem(context, '23', 'Actions'),
              _buildStatDivider(),
              _buildStatItem(context, '12', 'Rewards'),
            ],
          ).animate().fadeIn(),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 24,
      width: 1,
      color: Colors.grey.withAlpha(77),
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildLevelProgress(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level 5',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '500/1000 XP',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedProgressBar(
            progress: 0.5,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildTabBar(BuildContext context) {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'Achievements'),
        Tab(text: 'Activity'),
        Tab(text: 'Rewards'),
      ],
      indicatorColor: Theme.of(context).colorScheme.primary,
      labelColor: Theme.of(context).colorScheme.primary,
      unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
    );
  }

  Widget _buildTabContent(BuildContext context) {
    return SizedBox(
      height: 500,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildAchievementsTab(),
          _buildActivityTab(),
          _buildRewardsTab(),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab() {
    if (_isLoading) {
      return _buildShimmerLoading();
    }

    final achievements = [
      Achievement(
        id: '1',
        title: 'Tree Hugger',
        description: 'Plant your first tree',
        icon: Icons.park,
        isLocked: false,
      ),
      Achievement(
        id: '2',
        title: 'Waste Warrior',
        description: 'Recycle 100 items',
        icon: Icons.recycling,
        progressRequired: 100,
        currentProgress: 75,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        return AchievementCard(
          achievement: achievements[index],
        ).animate().fadeIn(delay: Duration(milliseconds: 100 * index));
      },
    );
  }

  Widget _buildActivityTab() {
    if (_isLoading) {
      return _buildShimmerLoading();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.eco,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: const Text('Planted a tree'),
            subtitle: const Text('2 days ago'),
            trailing: Text(
              '+100 pts',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 100 * index));
      },
    );
  }

  Widget _buildRewardsTab() {
    if (_isLoading) {
      return _buildShimmerLoading();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/images/reward_$index.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Eco Reward ${index + 1}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      '500 points',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 100 * index));
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 150,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    ).animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: const Duration(seconds: 1));
  }
}