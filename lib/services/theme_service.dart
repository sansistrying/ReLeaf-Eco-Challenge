// lib/services/theme_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences _prefs;
  
  ThemeService(this._prefs);

  ThemeMode get themeMode {
    final isLight = _prefs.getBool(_themeKey) ?? true;
    return isLight ? ThemeMode.light : ThemeMode.dark;
  }

  Future<void> toggleTheme() async {
    final isLight = themeMode == ThemeMode.light;
    await _prefs.setBool(_themeKey, !isLight);
    notifyListeners();
  }

  ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.light,
      ),
      // Add custom theme properties
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.dark,
      ),
      // Add custom theme properties
    );
  }
}

