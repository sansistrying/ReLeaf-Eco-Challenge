// lib/services/storage_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  final Map<String, dynamic> _storage = {};

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  Future<bool> saveString(String key, String value) async {
    try {
      _storage[key] = value;
      return true;
    } catch (e) {
      debugPrint('Error saving string: $e');
      return false;
    }
  }

  Future<bool> saveInt(String key, int value) async {
    try {
      _storage[key] = value;
      return true;
    } catch (e) {
      debugPrint('Error saving int: $e');
      return false;
    }
  }

  Future<bool> saveBool(String key, bool value) async {
    try {
      _storage[key] = value;
      return true;
    } catch (e) {
      debugPrint('Error saving bool: $e');
      return false;
    }
  }

  Future<bool> saveDouble(String key, double value) async {
    try {
      _storage[key] = value;
      return true;
    } catch (e) {
      debugPrint('Error saving double: $e');
      return false;
    }
  }

  Future<bool> saveObject(String key, Map<String, dynamic> value) async {
    try {
      _storage[key] = jsonEncode(value);
      return true;
    } catch (e) {
      debugPrint('Error saving object: $e');
      return false;
    }
  }

  Future<bool> saveList(String key, List<dynamic> value) async {
    try {
      _storage[key] = jsonEncode(value);
      return true;
    } catch (e) {
      debugPrint('Error saving list: $e');
      return false;
    }
  }

  String? getString(String key) {
    try {
      final value = _storage[key];
      return value is String ? value : null;
    } catch (e) {
      debugPrint('Error getting string: $e');
      return null;
    }
  }

  int? getInt(String key) {
    try {
      final value = _storage[key];
      return value is int ? value : null;
    } catch (e) {
      debugPrint('Error getting int: $e');
      return null;
    }
  }

  bool? getBool(String key) {
    try {
      final value = _storage[key];
      return value is bool ? value : null;
    } catch (e) {
      debugPrint('Error getting bool: $e');
      return null;
    }
  }

  double? getDouble(String key) {
    try {
      final value = _storage[key];
      return value is double ? value : null;
    } catch (e) {
      debugPrint('Error getting double: $e');
      return null;
    }
  }

  Map<String, dynamic>? getObject(String key) {
    try {
      final value = _storage[key];
      if (value is String) {
        return jsonDecode(value) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting object: $e');
      return null;
    }
  }

  List<dynamic>? getList(String key) {
    try {
      final value = _storage[key];
      if (value is String) {
        return jsonDecode(value) as List<dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting list: $e');
      return null;
    }
  }

  Future<bool> remove(String key) async {
    try {
      _storage.remove(key);
      return true;
    } catch (e) {
      debugPrint('Error removing key: $e');
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      _storage.clear();
      return true;
    } catch (e) {
      debugPrint('Error clearing storage: $e');
      return false;
    }
  }

  bool containsKey(String key) {
    return _storage.containsKey(key);
  }

  Set<String> getKeys() {
    return _storage.keys.toSet();
  }

  // Utility methods
  Future<bool> increment(String key, [int amount = 1]) async {
    try {
      final currentValue = getInt(key) ?? 0;
      return await saveInt(key, currentValue + amount);
    } catch (e) {
      debugPrint('Error incrementing value: $e');
      return false;
    }
  }

  Future<bool> decrement(String key, [int amount = 1]) async {
    try {
      final currentValue = getInt(key) ?? 0;
      return await saveInt(key, currentValue - amount);
    } catch (e) {
      debugPrint('Error decrementing value: $e');
      return false;
    }
  }

  Future<bool> appendToList(String key, dynamic value) async {
    try {
      final currentList = getList(key) ?? [];
      currentList.add(value);
      return await saveList(key, currentList);
    } catch (e) {
      debugPrint('Error appending to list: $e');
      return false;
    }
  }

  Future<bool> removeFromList(String key, dynamic value) async {
    try {
      final currentList = getList(key) ?? [];
      currentList.remove(value);
      return await saveList(key, currentList);
    } catch (e) {
      debugPrint('Error removing from list: $e');
      return false;
    }
  }

  // Debug methods
  void printStorage() {
    debugPrint('\nStorage Contents:');
    debugPrint('================');
    _storage.forEach((key, value) {
      debugPrint('$key: $value');
    });
    debugPrint('================\n');
  }
}

// Example usage:
/*
void main() async {
  final storage = StorageService();

  // Save values
  await storage.saveString('username', 'JohnDoe');
  await storage.saveInt('age', 25);
  await storage.saveBool('isLoggedIn', true);
  await storage.saveObject('user', {
    'id': '123',
    'name': 'John Doe',
    'email': 'john@example.com'
  });
  await storage.saveList('favorites', ['item1', 'item2', 'item3']);

  // Get values
  final username = storage.getString('username');
  final age = storage.getInt('age');
  final isLoggedIn = storage.getBool('isLoggedIn');
  final user = storage.getObject('user');
  final favorites = storage.getList('favorites');

  // Print storage contents
  storage.printStorage();

  // Utility operations
  await storage.increment('counter');
  await storage.appendToList('favorites', 'item4');
  
  // Clear specific key
  await storage.remove('username');
  
  // Clear all storage
  await storage.clear();
}
*/