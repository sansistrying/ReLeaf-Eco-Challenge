// lib/models/reward.dart
import 'package:flutter/material.dart';

@immutable
class Reward {
  final String id;
  final String title;
  final String description;
  final int points;
  final String image;
  final String category;
  final DateTime? expiryDate;
  final bool isAvailable;
  final int stockCount;
  final List<String> termsAndConditions;
  final Map<String, dynamic> metadata;
  final String? brandName;
  final String? brandLogo;
  final double? originalPrice;
  final double? discountedPrice;
  final List<String>? redemptionInstructions;

  const Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.image,
    this.category = 'General',
    this.expiryDate,
    this.isAvailable = true,
    this.stockCount = -1, // -1 means unlimited
    this.termsAndConditions = const [],
    this.metadata = const {},
    this.brandName,
    this.brandLogo,
    this.originalPrice,
    this.discountedPrice,
    this.redemptionInstructions,
  });

  bool get isExpired => expiryDate?.isBefore(DateTime.now()) ?? false;
  bool get isInStock => stockCount == -1 || stockCount > 0;
  bool get canBeRedeemed => isAvailable && !isExpired && isInStock;
  double get savingsPercentage => originalPrice != null && discountedPrice != null
      ? ((originalPrice! - discountedPrice!) / originalPrice! * 100)
      : 0.0;

  Reward copyWith({
    String? id,
    String? title,
    String? description,
    int? points,
    String? image,
    String? category,
    DateTime? expiryDate,
    bool? isAvailable,
    int? stockCount,
    List<String>? termsAndConditions,
    Map<String, dynamic>? metadata,
    String? brandName,
    String? brandLogo,
    double? originalPrice,
    double? discountedPrice,
    List<String>? redemptionInstructions,
  }) {
    return Reward(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      image: image ?? this.image,
      category: category ?? this.category,
      expiryDate: expiryDate ?? this.expiryDate,
      isAvailable: isAvailable ?? this.isAvailable,
      stockCount: stockCount ?? this.stockCount,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
      metadata: metadata ?? this.metadata,
      brandName: brandName ?? this.brandName,
      brandLogo: brandLogo ?? this.brandLogo,
      originalPrice: originalPrice ?? this.originalPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      redemptionInstructions: redemptionInstructions ?? this.redemptionInstructions,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'points': points,
    'image': image,
    'category': category,
    'expiryDate': expiryDate?.toIso8601String(),
    'isAvailable': isAvailable,
    'stockCount': stockCount,
    'termsAndConditions': termsAndConditions,
    'metadata': metadata,
    'brandName': brandName,
    'brandLogo': brandLogo,
    'originalPrice': originalPrice,
    'discountedPrice': discountedPrice,
    'redemptionInstructions': redemptionInstructions,
  };

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    points: json['points'],
    image: json['image'],
    category: json['category'],
    expiryDate: json['expiryDate'] != null 
        ? DateTime.parse(json['expiryDate'])
        : null,
    isAvailable: json['isAvailable'],
    stockCount: json['stockCount'],
    termsAndConditions: List<String>.from(json['termsAndConditions']),
    metadata: json['metadata'],
    brandName: json['brandName'],
    brandLogo: json['brandLogo'],
    originalPrice: json['originalPrice'],
    discountedPrice: json['discountedPrice'],
    redemptionInstructions: json['redemptionInstructions'] != null
        ? List<String>.from(json['redemptionInstructions'])
        : null,
  );
}

