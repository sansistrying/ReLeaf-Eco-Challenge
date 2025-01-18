// lib/models/eco_action.dart
import 'package:flutter/material.dart';

@immutable
class EcoAction {
  final String id;
  final String title;
  final String description;
  final int points;
  final IconData icon;
  final String category;
  final DateTime createdAt;
  final bool isVerified;
  final double carbonOffset;
  final List<String> requiredProof;
  final Map<String, dynamic> additionalData;
  final Color? color;
  final String? imageUrl;
  final int difficulty; // 1-5 scale

  const EcoAction({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.icon,
    this.category = 'General',
    DateTime? createdAt,
    this.isVerified = false,
    this.carbonOffset = 0.0,
    this.requiredProof = const [],
    this.additionalData = const {},
    this.color,
    this.imageUrl,
    this.difficulty = 1,
  }) : this.createdAt = createdAt ?? DateTime.now();

  EcoAction copyWith({
    String? id,
    String? title,
    String? description,
    int? points,
    IconData? icon,
    String? category,
    DateTime? createdAt,
    bool? isVerified,
    double? carbonOffset,
    List<String>? requiredProof,
    Map<String, dynamic>? additionalData,
    Color? color,
    String? imageUrl,
    int? difficulty,
  }) {
    return EcoAction(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      carbonOffset: carbonOffset ?? this.carbonOffset,
      requiredProof: requiredProof ?? this.requiredProof,
      additionalData: additionalData ?? this.additionalData,
      color: color ?? this.color,
      imageUrl: imageUrl ?? this.imageUrl,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'points': points,
    'iconCodePoint': icon.codePoint,
    'category': category,
    'createdAt': createdAt.toIso8601String(),
    'isVerified': isVerified,
    'carbonOffset': carbonOffset,
    'requiredProof': requiredProof,
    'additionalData': additionalData,
    'difficulty': difficulty,
  };

  factory EcoAction.fromJson(Map<String, dynamic> json) => EcoAction(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    points: json['points'],
    icon: IconData(json['iconCodePoint'], fontFamily: 'MaterialIcons'),
    category: json['category'],
    createdAt: DateTime.parse(json['createdAt']),
    isVerified: json['isVerified'],
    carbonOffset: json['carbonOffset'],
    requiredProof: List<String>.from(json['requiredProof']),
    additionalData: json['additionalData'],
    difficulty: json['difficulty'],
  );
}