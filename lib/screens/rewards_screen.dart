// lib/screens/rewards_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/reward_card.dart';
import '../models/reward.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/animated_progress_bar.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  bool _isLoading = true;
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Eco Products', 'Vouchers', 'Experiences', 'Donations'];

  @override
  void initState() {
    super.initState();
    _loadRewards();
  }

  Future<void> _loadRewards() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadRewards,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildPointsCard(context),
                  _buildCategoryFilter(context),
                ],
              ),
            ),
            _buildRewardsList(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Implement reward history
        },
        icon: const Icon(Icons.history),
        label: const Text('History'),
      ).animate().scale(delay: const Duration(milliseconds: 500)),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Rewards',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/rewards_background.jpg',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            _showFilterDialog(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            _showSearchDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildPointsCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Points',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1,500',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.stars,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedProgressBar(
              progress: 0.7,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              '500 more points until next tier',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildCategoryFilter(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(category),
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRewardsList(BuildContext context) {
    if (_isLoading) {
      return SliverToBoxAdapter(child: _buildShimmerLoading());
    }

    final rewards = [
      Reward(
        id: '1',
        title: 'Eco-friendly Water Bottle',
        description: 'Reusable water bottle made from recycled materials',
        points: 500,
        image: 'assets/images/water_bottle.jpg',
        category: 'Eco Products',
        brandName: 'EcoLife',
        originalPrice: 29.99,
        discountedPrice: 19.99,
      ),
      // Add more rewards...
    ];

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final reward = rewards[index % rewards.length];
            return RewardCard(
              reward: reward,
              onTap: () => _showRewardDetails(context, reward),
            ).animate().fadeIn(delay: Duration(milliseconds: 100 * index));
          },
          childCount: 10, // Adjust based on your needs
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Rewards',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              // Add filter options here
            ],
          ),
        );
      },
    );
  }

  void _showSearchDialog(BuildContext context) {
    showSearch(
      context: context,
      delegate: RewardSearchDelegate(),
    );
  }

  void _showRewardDetails(BuildContext context, Reward reward) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RewardDetailsSheet(reward: reward),
    );
  }
}

class RewardSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement search suggestions
    return Container();
  }
}

class _RewardDetailsSheet extends StatelessWidget {
  final Reward reward;

  const _RewardDetailsSheet({
    Key? key,
    required this.reward,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              // Add reward details UI here
            ],
          ),
        );
      },
    );
  }
}