import 'package:dio/dio.dart';
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
}
