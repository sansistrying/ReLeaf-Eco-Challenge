import 'package:flutter/material.dart';

class EcoAction {
  final String id;
  final String title;
  final String description;
  final int points;
  final IconData icon;

  EcoAction({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.icon,
  });
}

