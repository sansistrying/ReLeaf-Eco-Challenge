// lib/screens/social_feed_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../widgets/post_card.dart';
import '../widgets/comments_sheet.dart';
import '../models/post.dart';
import '../services/database_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({Key? key}) : super(key: key);

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  final _scrollController = ScrollController();
  final _databaseService = DatabaseService();
  bool _isLoading = false;
  bool _isGridView = false;
  String _selectedFilter = 'All';
  List<Post> _posts = [];
  int _currentPage = 0;
  static const int _postsPerPage = 10;

  final List<String> _filters = [
    'All',
    'Trending',
    'Following',
    'Nearby',
    'Tree Planting',
    'Recycling',
    'Clean Energy',
  ];

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadPosts() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final posts = await _databaseService.getPosts(
        limit: _postsPerPage,
        offset: _currentPage * _postsPerPage,
      );
      
      setState(() {
        if (_currentPage == 0) {
          _posts = posts;
        } else {
          _posts.addAll(posts);
        }
        _isLoading = false;
        _currentPage++;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading posts: $e')),
      );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadPosts();
    }
  }

  Future<void> _refreshPosts() async {
    _currentPage = 0;
    await _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildAppBar(context),
            _buildFilters(),
            _buildToggleView(),
            _isGridView ? _buildGridView() : _buildListView(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create post screen
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add_a_photo, color: Colors.white),
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
          'Community Feed',
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
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // Implement search
          },
        ),
        IconButton(
          icon: Icon(
            _isGridView ? Icons.view_agenda : Icons.grid_view,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isGridView = !_isGridView;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return SliverToBoxAdapter(
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isSelected,
                label: Text(filter),
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter;
                    _refreshPosts();
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
          },
        ),
      ),
    );
  }

  Widget _buildToggleView() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Posts',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_posts.length} posts',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView() {
    if (_posts.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('No posts yet'),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        itemBuilder: (context, index) {
          if (index >= _posts.length) {
            return _isLoading
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox();
          }

          final post = _posts[index];
          return GestureDetector(
            onTap: () => _showPostDetails(post),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: index.isEven ? 1 : 0.8,
                    child: Image.network(
                      post.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage(post.userAvatar),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                post.userName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          post.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 16,
                              color: post.isLiked ? Colors.red : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${post.likes}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.comment_outlined,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${post.comments}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: 100 * index));
        },
        childCount: _posts.length + (_isLoading ? 1 : 0),
      ),
    );
  }

  Widget _buildListView() {
    if (_posts.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('No posts yet'),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _posts.length) {
              return _isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : null;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PostCard(
                post: _posts[index],
                onLike: () => _likePost(_posts[index].id),
                onComment: () => _showComments(_posts[index]),
                onShare: () => _sharePost(_posts[index]),
              ).animate().fadeIn().slideX(),
            );
          },
          childCount: _posts.length + (_isLoading ? 1 : 0),
        ),
      ),
    );
  }

  void _showPostDetails(Post post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        title: Text(post.userName),
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      SliverToBoxAdapter(
                        child: PostCard(
                          post: post,
                          onLike: () => _likePost(post.id),
                          onComment: () => _showComments(post),
                          onShare: () => _sharePost(post),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _likePost(String postId) async {
    try {
      await _databaseService.likePost(postId);
      _refreshPosts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error liking post: $e')),
      );
    }
  }

  void _showComments(Post post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsSheet(post: post),
    );
  }

  Future<void> _sharePost(Post post) async {
    // Implement share functionality
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}