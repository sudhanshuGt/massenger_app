import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../presentation/login/login_screen.dart';
import '../repository/auth_repository.dart';
import '../repository/cloudinary_service.dart';

class AuthViewModel extends ChangeNotifier {

  final AuthService _authService = AuthService();
  bool isLoading = false;
  bool isUpdating = false;


  final AuthService _authRepo = AuthService();
  final CloudinaryService _cloudinary = CloudinaryService();

  String? uploadedImageUrl;
  bool isUploading = false;

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

      if (user.profile != null) {
        await prefs.setString("profile", user.profile!);
      }

      return true;
    } else {
      return false;
    }
  }


  Future<bool> updateProfile(UserModel updatedUser) async {
    isUpdating = true;
    notifyListeners();

    final user = await _authService.updateProfile(updatedUser);

    isUpdating = false;
    notifyListeners();

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("firstName", user.firstName);
      await prefs.setString("lastName", user.lastName);
      await prefs.setString("email", user.email);
      await prefs.setString("bio", user.bio);
      if (user.profile != null) {
        await prefs.setString("profile", user.profile!);
      }
      return true;
    } else {
      return false;
    }
  }



  Future<void> pickAndUploadProfileImage() async {
    isUploading = true;
    notifyListeners();

    final url = await _cloudinary.pickAndUploadImage(ImageSource.gallery);
    if (url != null) {
      uploadedImageUrl = url;
    }

    isUploading = false;
    notifyListeners();
  }

}
