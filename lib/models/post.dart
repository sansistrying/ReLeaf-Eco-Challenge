// lib/models/post.dart
class Post {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String imageUrl;
  final String description;
  final String actionType;
  final int points;
  final int likes;
  final int comments;
  final DateTime createdAt;
  final bool isLiked;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.imageUrl,
    required this.description,
    required this.actionType,
    required this.points,
    required this.likes,
    required this.comments,
    required this.createdAt,
    this.isLiked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final profile = json['profiles'] as Map<String, dynamic>;
    return Post(
      id: json['id'],
      userId: json['user_id'],
      userName: profile['name'] ?? 'Unknown',
      userAvatar: profile['avatar_url'] ?? '',
      imageUrl: json['image_url'],
      description: json['description'],
      actionType: json['action_type'],
      points: json['points'],
      likes: json['likes'],
      comments: json['comments'],
      createdAt: DateTime.parse(json['created_at']),
      isLiked: json['is_liked'] ?? false,
    );
  }
}