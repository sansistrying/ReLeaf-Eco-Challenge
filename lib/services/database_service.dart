// lib/services/database_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post.dart';
import 'package:logging/logging.dart';

class DatabaseService {
  final _supabase = Supabase.instance.client;
  final _logger = Logger('DatabaseService');

  // User Profile Methods
  Future<void> createUserProfile({
    required String userId,
    required String name,
    required String email,
    String? avatarUrl,
  }) async {
    try {
      await _supabase.from('profiles').insert({
        'id': userId,
        'name': name,
        'email': email,
        'avatar_url': avatarUrl,
        'points': 0,
      });
    } catch (e) {
      _logger.severe('Failed to create user profile: $e');
      throw Exception('Failed to create user profile');
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? avatarUrl,
    String? bio,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (bio != null) updates['bio'] = bio;

      await _supabase
          .from('profiles')
          .update(updates)
          .eq('id', userId);
    } catch (e) {
      _logger.severe('Failed to update user profile: $e');
      throw Exception('Failed to update user profile');
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      _logger.severe('Failed to get user profile: $e');
      throw Exception('Failed to get user profile');
    }
  }

  // Eco Actions Methods
  Future<void> saveEcoAction({
    required String userId,
    required String actionType,
    required int points,
    required String imageUrl,
    required String description,
    double? latitude,
    double? longitude,
    bool shouldPost = false,
  }) async {
    try {
      final actionResponse = await _supabase.from('eco_actions').insert({
        'user_id': userId,
        'action_type': actionType,
        'points': points,
        'image_url': imageUrl,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
      }).select('id').single();

      // Update user points
      await _supabase.rpc('update_user_points', params: {
        'user_id': userId,
        'points_to_add': points,
      });

      // Create social post if requested
      if (shouldPost) {
        await createPost(
          userId: userId,
          imageUrl: imageUrl,
          description: description,
          actionType: actionType,
          points: points,
          ecoActionId: actionResponse['id'],
        );
      }
    } catch (e) {
      _logger.severe('Failed to save eco action: $e');
      throw Exception('Failed to save eco action');
    }
  }

  Future<List<Map<String, dynamic>>> getUserEcoActions(String userId) async {
    try {
      final response = await _supabase
          .from('eco_actions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      _logger.severe('Failed to get eco actions: $e');
      throw Exception('Failed to get eco actions');
    }
  }

  // Social Posts Methods
  Future<void> createPost({
    required String userId,
    required String imageUrl,
    required String description,
    required String actionType,
    required int points,
    String? ecoActionId,
  }) async {
    try {
      await _supabase.from('posts').insert({
        'user_id': userId,
        'image_url': imageUrl,
        'description': description,
        'action_type': actionType,
        'points': points,
        'eco_action_id': ecoActionId,
        'likes': 0,
        'comments': 0,
      });
    } catch (e) {
      _logger.severe('Failed to create post: $e');
      throw Exception('Failed to create post');
    }
  }

  Future<List<Post>> getPosts({
    int limit = 10,
    int offset = 0,
    String? userId,
  }) async {
    try {
      var query = _supabase
          .from('posts')
          .select('''
            *,
            profiles!inner (
              name,
              avatar_url
            ),
            likes (
              user_id
            )
          ''');

      // Apply filters
      if (userId != null) {
        query = query.contains('user_id', userId);
      }

      // Apply ordering and pagination
      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return response.map((post) {
        final likes = post['likes'] as List;
        final isLiked = likes.any((like) => 
          like['user_id'] == _supabase.auth.currentUser?.id);
        return Post.fromJson({...post, 'is_liked': isLiked});
      }).toList();
    } catch (e) {
      _logger.severe('Failed to get posts: $e');
      throw Exception('Failed to get posts');
    }
  }

  Future<void> likePost(String postId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Check if already liked
      final existing = await _supabase
          .from('likes')
          .select()
          .eq('post_id', postId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existing == null) {
        // Like the post
        await _supabase.from('likes').insert({
          'post_id': postId,
          'user_id': userId,
        });

        // Increment likes count
        await _supabase.rpc('increment_post_likes', params: {
          'post_id': postId,
        });
      } else {
        // Unlike the post
        await _supabase
            .from('likes')
            .delete()
            .eq('post_id', postId)
            .eq('user_id', userId);

        // Decrement likes count
        await _supabase.rpc('decrement_post_likes', params: {
          'post_id': postId,
        });
      }
    } catch (e) {
      _logger.severe('Failed to like/unlike post: $e');
      throw Exception('Failed to like/unlike post');
    }
  }

  // Comments Methods
  Future<void> addComment({
    required String postId,
    required String comment,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _supabase.from('comments').insert({
        'post_id': postId,
        'user_id': userId,
        'comment': comment,
      });

      // Increment comments count
      await _supabase.rpc('increment_post_comments', params: {
        'post_id': postId,
      });
    } catch (e) {
      _logger.severe('Failed to add comment: $e');
      throw Exception('Failed to add comment');
    }
  }

  Future<List<Map<String, dynamic>>> getComments(String postId) async {
    try {
      final response = await _supabase
          .from('comments')
          .select('''
            *,
            profiles!inner (
              name,
              avatar_url
            )
          ''')
          .eq('post_id', postId)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      _logger.severe('Failed to get comments: $e');
      throw Exception('Failed to get comments');
    }
  }

  // Achievement Methods
  Future<void> checkAndAwardAchievements(String userId) async {
    try {
      await _supabase.rpc('check_achievements', params: {
        'user_id': userId,
      });
    } catch (e) {
      _logger.severe('Failed to check achievements: $e');
      throw Exception('Failed to check achievements');
    }
  }

  // Statistics Methods
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      final response = await _supabase.rpc('get_user_stats', params: {
        'user_id': userId,
      });
      return Map<String, dynamic>.from(response);
    } catch (e) {
      _logger.severe('Failed to get user stats: $e');
      throw Exception('Failed to get user stats');
    }
  }

  // Real-time subscriptions
  Stream<List<Map<String, dynamic>>> subscribeToNewPosts() {
    return _supabase
        .from('posts')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((list) => List<Map<String, dynamic>>.from(list));
  }

  Stream<List<Map<String, dynamic>>> subscribeToComments(String postId) {
    return _supabase
        .from('comments')
        .stream(primaryKey: ['id'])
        .eq('post_id', postId)
        .order('created_at')
        .map((list) => List<Map<String, dynamic>>.from(list));
  }
}