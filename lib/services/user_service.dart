import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/user.dart';

class UserService {
  static const _userKey = 'authenticated_user';

  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$host/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Invalid username or password');
    }
    final user = User.fromJson(jsonDecode(response.body));
    await saveUser(user);
    return user;
  }

  Future<void> saveUser(User user) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<User?> getSavedUser() async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString(_userKey);
    if (value == null) return null;
    try {
      final user = User.fromJson(jsonDecode(value));
      if (!user.hasValidSession) {
        await clearUser();
        return null;
      }
      return user;
    } catch (_) {
      await clearUser();
      return null;
    }
  }

  Future<void> clearUser() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_userKey);
  }
}
