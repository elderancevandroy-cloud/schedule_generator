import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.system;
  SharedPreferences? _prefs;

  ThemeProvider() {
    _loadThemeMode();
  }

  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Load saved theme mode
  Future<void> _loadThemeMode() async {
    _prefs = await SharedPreferences.getInstance();
    final savedTheme = _prefs?.getString(_themeKey);
    
    if (savedTheme != null) {
      _themeMode = _parseThemeMode(savedTheme);
      notifyListeners();
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs?.setString(_themeKey, mode.toString());
    notifyListeners();
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  /// Parse theme mode from string
  ThemeMode _parseThemeMode(String themeString) {
    switch (themeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}