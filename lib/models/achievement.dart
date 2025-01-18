// lib/models/achievement.dart
import 'package:flutter/material.dart';

@immutable
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final DateTime? unlockedAt;
  final int progressRequired;
  final int currentProgress;
  final String category;
  final List<String> rewards;
  final Color? color;
  final bool isLocked;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.unlockedAt,
    this.progressRequired = 1,
    this.currentProgress = 0,
    this.category = 'General',
    this.rewards = const [],
    this.color,
    this.isLocked = true,
  });

  bool get isUnlocked => unlockedAt != null;
  double get progressPercentage => (currentProgress / progressRequired).clamp(0.0, 1.0);

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    DateTime? unlockedAt,
    int? progressRequired,
    int? currentProgress,
    String? category,
    List<String>? rewards,
    Color? color,
    bool? isLocked,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progressRequired: progressRequired ?? this.progressRequired,
      currentProgress: currentProgress ?? this.currentProgress,
      category: category ?? this.category,
      rewards: rewards ?? this.rewards,
      color: color ?? this.color,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'iconCodePoint': icon.codePoint,
    'unlockedAt': unlockedAt?.toIso8601String(),
    'progressRequired': progressRequired,
    'currentProgress': currentProgress,
    'category': category,
    'rewards': rewards,
    'isLocked': isLocked,
  };

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    icon: IconData(json['iconCodePoint'], fontFamily: 'MaterialIcons'),
    unlockedAt: json['unlockedAt'] != null 
        ? DateTime.parse(json['unlockedAt'])
        : null,
    progressRequired: json['progressRequired'],
    currentProgress: json['currentProgress'],
    category: json['category'],
    rewards: List<String>.from(json['rewards']),
    isLocked: json['isLocked'],
  );
}
