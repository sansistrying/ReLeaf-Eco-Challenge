// lib/services/storage_service.dart
import 'dart:io';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final _supabase = Supabase.instance.client;

  Future<String> uploadImage(File imageFile, String userId) async {
    try {
      final fileExt = extension(imageFile.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExt';
      final filePath = 'eco-actions/$userId/$fileName';
      
      await _supabase.storage.from('images').upload(
        filePath,
        imageFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );
      
      return _supabase.storage.from('images').getPublicUrl(filePath);
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}