// lib/models/user.dart
import 'package:flutter/material.dart';

@immutable
class User {
  final String id;
  final String name;
  final String email;
  final int points;
  final String avatar;
  final UserLevel level;
  final List<String> achievements;
  final Map<String, int> stats;
  final UserPreferences preferences;
  final DateTime joinDate;
  final List<String> completedActions;
  final List<String> redeemedRewards;
  final double totalCarbonOffset;
  final String? referralCode;
  final List<String> friends;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.points,
    required this.avatar,
    required this.level,
    this.achievements = const [],
    this.stats = const {},
    required this.preferences,
    required this.joinDate,
    this.completedActions = const [],
    this.redeemedRewards = const [],
    this.totalCarbonOffset = 0.0,
    this.referralCode,
    this.friends = const [],
  });

  bool get isNewUser => DateTime.now().difference(joinDate).inDays < 7;
  int get totalAchievements => achievements.length;
  int get completedActionsCount => completedActions.length;
  bool get hasReferralCode => referralCode != null;

  User copyWith({
    String? id,
    String? name,
    String? email,
    int? points,
    String? avatar,
    UserLevel? level,
    List<String>? achievements,
    Map<String, int>? stats,
    UserPreferences? preferences,
    DateTime? joinDate,
    List<String>? completedActions,
    List<String>? redeemedRewards,
    double? totalCarbonOffset,
    String? referralCode,
    List<String>? friends,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      points: points ?? this.points,
      avatar: avatar ?? this.avatar,
      level: level ?? this.level,
      achievements: achievements ?? this.achievements,
      stats: stats ?? this.stats,
      preferences: preferences ?? this.preferences,
      joinDate: joinDate ?? this.joinDate,
      completedActions: completedActions ?? this.completedActions,
      redeemedRewards: redeemedRewards ?? this.redeemedRewards,
      totalCarbonOffset: totalCarbonOffset ?? this.totalCarbonOffset,
      referralCode: referralCode ?? this.referralCode,
      friends: friends ?? this.friends,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'points': points,
    'avatar': avatar,
    'level': level.toJson(),
    'achievements': achievements,
    'stats': stats,
    'preferences': preferences.toJson(),
    'joinDate': joinDate.toIso8601String(),
    'completedActions': completedActions,
    'redeemedRewards': redeemedRewards,
    'totalCarbonOffset': totalCarbonOffset,
    'referralCode': referralCode,
    'friends': friends,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    points: json['points'],
    avatar: json['avatar'],
    level: UserLevel.fromJson(json['level']),
    achievements: List<String>.from(json['achievements']),
    stats: Map<String, int>.from(json['stats']),
    preferences: UserPreferences.fromJson(json['preferences']),
    joinDate: DateTime.parse(json['joinDate']),
    completedActions: List<String>.from(json['completedActions']),
    redeemedRewards: List<String>.from(json['redeemedRewards']),
    totalCarbonOffset: json['totalCarbonOffset'],
    referralCode: json['referralCode'],
    friends: List<String>.from(json['friends']),
  );
}

@immutable
class UserLevel {
  final int level;
  final int currentXP;
  final int requiredXP;
  final String title;

  const UserLevel({
    required this.level,
    required this.currentXP,
    required this.requiredXP,
    required this.title,
  });

  double get progress => currentXP / requiredXP;

  Map<String, dynamic> toJson() => {
    'level': level,
    'currentXP': currentXP,
    'requiredXP': requiredXP,
    'title': title,
  };

  factory UserLevel.fromJson(Map<String, dynamic> json) => UserLevel(
    level: json['level'],
    currentXP: json['currentXP'],
    requiredXP: json['requiredXP'],
    title: json['title'],
  );
}

@immutable
class UserPreferences {
  final bool darkMode;
  final bool notifications;
  final String language;
  final List<String> interests;
  final bool locationTracking;

  const UserPreferences({
    this.darkMode = false,
    this.notifications = true,
    this.language = 'en',
    this.interests = const [],
    this.locationTracking = false,
  });

  Map<String, dynamic> toJson() => {
    'darkMode': darkMode,
    'notifications': notifications,
    'language': language,
    'interests': interests,
    'locationTracking': locationTracking,
  };

  factory UserPreferences.fromJson(Map<String, dynamic> json) => UserPreferences(
    darkMode: json['darkMode'],
    notifications: json['notifications'],
    language: json['language'],
    interests: List<String>.from(json['interests']),
    locationTracking: json['locationTracking'],
  );
}