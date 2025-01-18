// lib/services/storage_service.dart
import 'package:shared_preferences.dart';
import 'dart:convert';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  Future<bool> saveObject(String key, Map<String, dynamic> value) async {
    return await _prefs.setString(key, json.encode(value));
  }

  String? getString(String key) => _prefs.getString(key);
  int? getInt(String key) => _prefs.getInt(key);
  bool? getBool(String key) => _prefs.getBool(key);

  Map<String, dynamic>? getObject(String key) {
    final String? jsonString = _prefs.getString(key);
    if (jsonString == null) return null;
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  Future<bool> remove(String key) => _prefs.remove(key);
  Future<bool> clear() => _prefs.clear();
}

