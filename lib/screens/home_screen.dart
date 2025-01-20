// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          _scrollOffset > 130 ? 'ReLeaf' : '',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                    Theme.of(context).colorScheme.primary.withAlpha(178),
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
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
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
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        StatsCard(
          title: 'Carbon Offset',
          value: '2,500 kg',
          icon: Icons.eco,
          color: Colors.green,
        ),
        StatsCard(
          title: 'Trees Planted',
          value: '150',
          icon: Icons.park,
          color: Colors.brown,
        ),
        StatsCard(
          title: 'Total Points',
          value: '5,000',
          icon: Icons.stars,
          color: Colors.amber,
          isWide: true,
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
      EcoAction(
        id: '2',
        title: 'Recycle Electronics',
        description: 'Properly dispose of old electronics',
        points: 50,
        icon: Icons.phone_android,
        category: 'Recycling',
        difficulty: 1,
      ),
      EcoAction(
        id: '3',
        title: 'Use Public Transport',
        description: 'Commute using public transportation',
        points: 30,
        icon: Icons.directions_bus,
        category: 'Transportation',
        difficulty: 1,
      ),
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
        ).animate().fadeIn(delay: Duration(milliseconds: 100 * index));
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
        LeaderboardCard(topUsers: _getDummyUsers()),
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
      User(
        id: '2',
        name: 'Bob Smith',
        email: 'bob@example.com',
        points: 1100,
        avatar: 'assets/images/avatar2.png',
        level: UserLevel(
          level: 4,
          currentXP: 300,
          requiredXP: 1000,
          title: 'Nature Guardian',
        ),
        preferences: const UserPreferences(),
        joinDate: DateTime.now().subtract(const Duration(days: 90)),
      ),
      User(
        id: '3',
        name: 'Charlie Brown',
        email: 'charlie@example.com',
        points: 1000,
        avatar: 'assets/images/avatar3.png',
        level: UserLevel(
          level: 4,
          currentXP: 200,
          requiredXP: 1000,
          title: 'Earth Protector',
        ),
        preferences: const UserPreferences(),
        joinDate: DateTime.now().subtract(const Duration(days: 80)),
      ),
    ];
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

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        // Implement quick action
      },
      icon: const Icon(Icons.add_photo_alternate),
      label: const Text('Quick Action'),
    ).animate().scale(delay: const Duration(milliseconds: 500));
  }
}