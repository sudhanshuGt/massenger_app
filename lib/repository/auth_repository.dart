import 'package:dio/dio.dart';
import 'package:messanger_app/model/update_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://172.20.10.12:8080/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  AuthService() {
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
      logPrint: (obj) => print("🔐 $obj"),
    ));
  }

  Future<bool> signup(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post('/auth/signup', data: body);
      return response.statusCode == 201;
    } catch (e) {
      print("❌ Signup failed: $e");
      return false;
    }
  }

  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {"username": username, "password": password},
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print("❌ Login failed: $e");
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<UpdateProfileModel?> updateProfile(UserModel updatedUser) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) throw Exception("Token not found");

      final response = await _dio.post(
        '/auth/profile',
        data: {
          "firstName": updatedUser.firstName,
          "lastName": updatedUser.lastName,
          "email": updatedUser.email,
          "bio": updatedUser.bio,
          "profile": updatedUser.profile,
          "username": updatedUser.username,
        },
        options: Options(headers: {
          "Authorization": "Bearer $token",
        }),
      );

      if (response.statusCode == 200) {
        return UpdateProfileModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print("❌ Profile update failed: $e");
      return null;
    }
  }

}
