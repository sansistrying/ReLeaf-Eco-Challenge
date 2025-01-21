// lib/services/database_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final _supabase = Supabase.instance.client;

  Future<void> saveEcoAction({
    required String userId,
    required String actionType,
    required int points,
    required String imageUrl,
    required double? latitude,
    required double? longitude,
  }) async {
    try {
      await _supabase.from('eco_actions').insert({
        'user_id': userId,
        'action_type': actionType,
        'points': points,
        'image_url': imageUrl,
        'latitude': latitude,
        'longitude': longitude,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to save eco action: $e');
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
      throw Exception('Failed to get eco actions: $e');
    }
  }

  Future<void> updateUserPoints(String userId, int points) async {
    try {
      await _supabase.from('profiles').update({
        'points': points,
      }).eq('id', userId);
    } catch (e) {
      throw Exception('Failed to update points: $e');
    }
  }
}