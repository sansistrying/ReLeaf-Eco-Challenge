// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/eco_action_card.dart';
import '../widgets/leaderboard_card.dart';
import '../models/eco_action.dart';
import '../models/user.dart';
import '../widgets/animated_progress_bar.dart';
import '../widgets/challenge_card.dart';
import '../widgets/stats_card.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  late ScrollController _scrollController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate data loading
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeSection(),
                    const SizedBox(height: 24),
                    _buildDailyProgress(),
                    const SizedBox(height: 24),
                    _buildCurrentChallenge(),
                    const SizedBox(height: 24),
                    _buildImpactStats(context),
                    const SizedBox(height: 24),
                    _buildEcoActionsSection(),
                    const SizedBox(height: 24),
                    _buildLeaderboardSection(),
                  ].animate(interval: const Duration(milliseconds: 100))
                   .fadeIn()
                   .slideX(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: theme.colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          _scrollOffset > 130 ? 'ReLeaf' : '',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/nature_background.jpg',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    theme.colorScheme.primary.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Implement notifications
          },
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Implement search
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    if (_isLoading) {
      return _buildShimmerLoading();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, John!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          DateFormat('EEEE, MMMM d').format(DateTime.now()),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyProgress() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            AnimatedProgressBar(
              progress: 0.7,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              '70% of daily goal completed',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentChallenge() {
    return ChallengeCard(
      title: 'Weekly Challenge',
      description: 'Plant 3 trees this week',
      progress: 0.33,
      daysLeft: 4,
      reward: '500 points',
      onTap: () {
        // Implement challenge details
      },
    );
  }

  Widget _buildImpactStats(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: StatsCard(
            title: 'Carbon Offset',
            value: '2,500 kg',
            icon: Icons.eco,
            color: Colors.green,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: StatsCard(
            title: 'Trees Planted',
            value: '150',
            icon: Icons.park,
            color: Colors.brown,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1,
          child: StatsCard(
            title: 'Total Points',
            value: '5,000',
            icon: Icons.stars,
            color: Colors.amber,
            isWide: true,
          ),
        ),
      ],
    );
  }

  Widget _buildEcoActionsSection() {
    if (_isLoading) {
      return _buildShimmerLoading();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Eco Actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            TextButton(
              onPressed: () {
                // Implement view all actions
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildEcoActions(),
      ],
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
        category: 'Planting',
        difficulty: 2,
      ),
      // Add more actions...
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: EcoActionCard(
            action: actions[index],
            onTap: () {
              // Implement action details
            },
          ),
        );
      },
    );
  }

  Widget _buildLeaderboardSection() {
    if (_isLoading) {
      return _buildShimmerLoading();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leaderboard',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        LeaderboardCard(
          topUsers: _getDummyUsers(),
          onTap: (User user) {
            // Implement user profile view
          },
        ),
      ],
    );
  }

  List<User> _getDummyUsers() {
    return [
      User(
        id: '1',
        name: 'Alice Johnson',
        email: 'alice@example.com',
        points: 1200,
        avatar: 'assets/images/avatar1.png',
        level: UserLevel(
          level: 5,
          currentXP: 500,
          requiredXP: 1000,
          title: 'Eco Warrior',
        ),
        preferences: const UserPreferences(),
        joinDate: DateTime.now().subtract(const Duration(days: 100)),
      ),
      // Add more users...
    ];
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 24,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Container(
            width: 150,
            height: 16,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        // Implement quick action
      },
      label: const Text('Quick Action'),
      icon: const Icon(Icons.add_photo_alternate),
    ).animate()
      .scale(delay: const Duration(milliseconds: 500));
  }
}