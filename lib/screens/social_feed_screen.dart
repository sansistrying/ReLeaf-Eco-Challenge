// lib/screens/social_feed_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/post_card.dart';
import '../widgets/comments_sheet.dart';
import '../models/post.dart';
import '../services/database_service.dart';

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({Key? key}) : super(key: key);

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  final _scrollController = ScrollController();
  final _databaseService = DatabaseService();
  bool _isLoading = false;
  List<Post> _posts = [];
  int _currentPage = 0;
  static const int _postsPerPage = 10;

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
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 60,
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
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.filter_list,
                    color: Colors.white,  // Make icon white to match
                  ),
                  onPressed: () {
                    // Show filter options
                  },
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= _posts.length) {
                      if (_isLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return null;
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
            ),
          ],
        ),
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