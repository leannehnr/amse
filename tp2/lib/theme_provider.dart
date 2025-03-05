import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;
  bool _isDarkMode;

  ThemeProvider()
      : _themeData = ThemeData.light(),
        _isDarkMode = false {
    _loadTheme();
  }

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _themeData = _isDarkMode ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
    _saveTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeData = _isDarkMode ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }
}
