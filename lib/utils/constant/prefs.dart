import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const String _userRoleKey = 'userRole';
  late SharedPreferences _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save user role
  Future<void> save(String role) async {
    await _prefs.setString(_userRoleKey, role);
  }

  // Get user role
  String get() {
    return _prefs.getString(_userRoleKey) ?? '';
  }

  // Delete user role
  Future<void> delete() async {
    await _prefs.remove(_userRoleKey);
  }
}