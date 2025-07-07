import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/login/login_screen.dart';
import '../repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isLoading = false;

  final AuthService _authRepo = AuthService();


  Future<void> logout(BuildContext context) async {
    await _authRepo.logout();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  Future<bool> signup(Map<String, dynamic> body) async {
    isLoading = true;
    notifyListeners();
    final result = await _authService.signup(body);
    isLoading = false;
    notifyListeners();
    return result;
  }

  Future<bool> login(String username, String password) async {
    isLoading = true;
    notifyListeners();
    final user = await _authService.login(username, password);
    isLoading = false;
    notifyListeners();

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", user.token);
      await prefs.setString("username", user.username);
      await prefs.setString("firstName", user.firstName);
      await prefs.setString("lastName", user.lastName);
      await prefs.setString("email", user.email);
      await prefs.setString("bio", user.bio);
      return true;
    } else {
      return false;
    }
  }
}
