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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _leaderboardTabController;
  bool _isLoading = true;
  late ScrollController _scrollController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _leaderboardTabController = TabController(length: 2, vsync: this);
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
    _leaderboardTabController.dispose();
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
                    const SizedBox(height: 16),
                    _buildCompactPointsDisplay(),
                    const SizedBox(height: 16),
                    _buildWeeklyChallenges(),
                    const SizedBox(height: 24),
                    _buildEcoActionsList(),
                    const SizedBox(height: 24),
                    _buildImpactStats(context),
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
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 60,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'ReLeaf',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withAlpha(178),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    if (_isLoading) return _buildShimmerLoading();
    
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

  Widget _buildCompactPointsDisplay() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.stars,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              '1,500 Points',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Spacer(),
            Text(
              '500 until next level',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChallenges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Challenges',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ChallengeCard(
          title: 'Plant Trees Challenge',
          description: 'Plant 3 trees this week',
          progress: 0.33,
          daysLeft: 4,
          reward: '500 points',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildEcoActionsList() {
    final actions = [
      EcoAction(
        id: '1',
        title: 'Plant a Tree',
        description: 'Plant a tree in your local community',
        points: 100,
        icon: Icons.nature,
        category: 'Planting',
      ),
      EcoAction(
        id: '2',
        title: 'Recycle Electronics',
        description: 'Properly dispose of old electronics',
        points: 50,
        icon: Icons.phone_android,
        category: 'Recycling',
      ),
      EcoAction(
        id: '3',
        title: 'Use Public Transport',
        description: 'Commute using public transportation',
        points: 30,
        icon: Icons.directions_bus,
        category: 'Transportation',
      ),
    ];

    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'This Week\'s Eco Actions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...actions.map((action) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: EcoActionCard(
              action: action,
              onTap: () {},
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildImpactStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Impact',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'Carbon Offset',
                value: '2,500 kg',
                icon: Icons.eco,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                title: 'Trees Planted',
                value: '150',
                icon: Icons.park,
                color: Colors.brown,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLeaderboardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leaderboard',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              TabBar(
                controller: _leaderboardTabController,
                tabs: const [
                  Tab(text: 'Friends'),
                  Tab(text: 'Global'),
                ],
              ),
              SizedBox(
                height: 200,
                child: TabBarView(
                  controller: _leaderboardTabController,
                  children: [
                    _buildLeaderboardList(isFriends: true),
                    _buildLeaderboardList(isFriends: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList({required bool isFriends}) {
    final users = isFriends ? _getDummyFriends() : _getDummyGlobalUsers();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(user.avatar),
          ),
          title: Text(user.name),
          trailing: Text(
            '${user.points} pts',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  List<User> _getDummyFriends() {
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
        joinDate: DateTime.now(),
      ),
      // Add more friends...
    ];
  }

  List<User> _getDummyGlobalUsers() {
    return [
      User(
        id: '2',
        name: 'Bob Smith',
        email: 'bob@example.com',
        points: 2000,
        avatar: 'assets/images/avatar2.png',
        level: UserLevel(
          level: 7,
          currentXP: 800,
          requiredXP: 1000,
          title: 'Nature Guardian',
        ),
        preferences: const UserPreferences(),
        joinDate: DateTime.now(),
      ),
      // Add more global users...
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
}