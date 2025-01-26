// lib/screens/rewards_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/reward_card.dart';
import '../models/reward.dart';
import '../widgets/animated_progress_bar.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  bool _isLoading = true;
  String _selectedCategory = 'All';
  final List<String> _categories = const [
    'All',
    'Eco Products',
    'Vouchers',
    'Experiences',
    'Donations'
  ];

  final List<Reward> _rewards = [  // Remove const from here
    Reward(
      id: '1',
      title: 'Bamboo Water Bottle',
      description: 'Sustainable bamboo water bottle with stainless steel interior. 500ml capacity.',
      points: 500,
      image: 'assets/images/water_bottle.jpg',
      category: 'Eco Products',
      brandName: 'EcoLife',
      originalPrice: 25.99,
      discountedPrice: 19.99,
      stockCount: 50,
      termsAndConditions: ['Valid for 3 months', 'One redemption per user'],
      redemptionInstructions: ['Show QR code at store', 'Present ID for verification'],
    ),
    Reward(
      id: '2',
      title: 'Organic Cotton T-shirt',
      description: 'Comfortable t-shirt made from 100% organic cotton.',
      points: 750,
      image: 'assets/images/tshirt.jpg',
      category: 'Eco Products',
      brandName: 'GreenGear',
      originalPrice: 45.99,
      discountedPrice: 35.99,
      stockCount: 30,
      termsAndConditions: ['Available in S, M, L sizes', 'Color may vary'],
      redemptionInstructions: ['Choose size at checkout', 'Allow 5-7 days for delivery'],
    ),
    Reward(
      id: '3',
      title: 'Solar Power Bank',
      description: '10000mAh solar-powered power bank with dual USB ports.',
      points: 1000,
      image: 'assets/images/power_bank.jpg',
      category: 'Eco Products',
      brandName: 'EcoCharge',
      originalPrice: 59.99,
      discountedPrice: 49.99,
      stockCount: 25,
      termsAndConditions: ['1 year warranty', 'International shipping available'],
      redemptionInstructions: ['Redeem online', 'Enter shipping details'],
    ),
    Reward(
      id: '4',
      title: 'Local Farm Voucher',
      description: '\$50 voucher for your local organic farm market.',
      points: 400,
      image: 'assets/images/farm_voucher.jpg',
      category: 'Vouchers',
      brandName: 'Local Farms Co-op',
      originalPrice: 50.00,
      discountedPrice: 50.00,
      termsAndConditions: ['Valid at participating farms only', 'No cash value'],
      redemptionInstructions: ['Show digital voucher at checkout'],
    ),
    Reward(
      id: '5',
      title: 'Electric Bike Rental',
      description: '2-hour electric bike rental for eco-friendly transportation.',
      points: 300,
      image: 'assets/images/bike_rental.jpg',
      category: 'Experiences',
      brandName: 'Green Wheels',
      originalPrice: 30.00,
      discountedPrice: 25.00,
      termsAndConditions: ['Helmet included', 'Valid ID required', 'Age 18+ only'],
      redemptionInstructions: ['Book time slot in advance', 'Present ID at location'],
    ),
    Reward(
      id: '6',
      title: 'Reusable Shopping Set',
      description: 'Complete set of reusable shopping bags and produce nets.',
      points: 600,
      image: 'assets/images/shopping_set.jpg',
      category: 'Eco Products',
      brandName: 'Zero Waste Gear',
      originalPrice: 35.99,
      discountedPrice: 29.99,
      stockCount: 40,
      termsAndConditions: ['Set includes 5 bags', 'Machine washable'],
      redemptionInstructions: ['Redeem at partner stores', 'Show redemption code'],
    ),
    Reward(
      id: '7',
      title: 'Tree Planting Kit',
      description: 'Complete kit with seeds, soil, and tools to plant your own tree.',
      points: 450,
      image: 'assets/images/planting_kit.jpg',
      category: 'Eco Products',
      brandName: 'GreenThumb',
      originalPrice: 40.00,
      discountedPrice: 32.99,
      stockCount: 35,
      termsAndConditions: ['Includes care guide', 'Seasonal varieties may vary'],
      redemptionInstructions: ['Collect from local garden center'],
    ),
    Reward(
      id: '8',
      title: 'Eco Workshop Pass',
      description: 'Access to a sustainable living workshop in your area.',
      points: 800,
      image: 'assets/images/workshop.jpg',
      category: 'Experiences',
      brandName: 'EcoLearn',
      originalPrice: 75.00,
      discountedPrice: 65.00,
      termsAndConditions: ['Advanced booking required', 'Subject to availability'],
      redemptionInstructions: ['Book online using code', 'Attend in person'],
    ),
    Reward(
      id: '9',
      title: 'Wildlife Protection Donation',
      description: 'Donate to protect endangered species in your region.',
      points: 500,
      image: 'assets/images/wildlife.jpg',
      category: 'Donations',
      brandName: 'Wildlife Foundation',
      termsAndConditions: ['100% of points go to conservation', 'Tax deductible'],
      redemptionInstructions: ['Choose conservation project', 'Receive certificate'],
    ),
    Reward(
      id: '10',
      title: 'Eco-Friendly Cafe Voucher',
      description: '\$25 voucher for sustainable coffee shop.',
      points: 250,
      image: 'assets/images/cafe_voucher.jpg',
      category: 'Vouchers',
      brandName: 'Green Bean Cafe',
      originalPrice: 25.00,
      discountedPrice: 25.00,
      termsAndConditions: ['Valid at all locations', 'No minimum purchase'],
      redemptionInstructions: ['Show QR code at payment'],
    ),
];

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
      expandedHeight: 60,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Rewards',
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
          icon: const Icon(
            Icons.filter_list,
            color: Colors.white,
          ),
          onPressed: () {
            // Implement filtering
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            // Implement search
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

    final filteredRewards = _selectedCategory == 'All'
        ? _rewards
        : _rewards.where((r) => r.category == _selectedCategory).toList();

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
            final reward = filteredRewards[index];
            return RewardCard(
              reward: reward,
              onTap: () => _showRewardDetails(context, reward),
            ).animate().fadeIn(delay: Duration(milliseconds: 100 * index));
          },
          childCount: filteredRewards.length,
        ),
      ),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  reward.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      reward.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.stars,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${reward.points} points',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (reward.brandName != null) ...[
                const SizedBox(height: 8),
                Text(
                  'By ${reward.brandName}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                reward.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              if (reward.originalPrice != null) ...[
                Row(
                  children: [
                    Text(
                      '\$${reward.discountedPrice?.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${reward.originalPrice?.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Redemption'),
                      content: Text(
                        'Are you sure you want to redeem ${reward.title} for ${reward.points} points?'
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Successfully redeemed ${reward.title}!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Redeem Now'),
              ),
            ],
          ),
        );
      },
    );
  }
}