import 'package:dio/dio.dart';
import 'package:messanger_app/model/search_users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/chat_conversation.dart';
import '../model/chat_message.dart';

class ChatService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://172.20.10.12:8080/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  ChatService() {
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: false,
      responseHeader: false,
      responseBody: true,
      error: true,
      logPrint: (object) => print("📦 $object"),
    ));
  }

  Future<List<ChatModel>> fetchChats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final response = await _dio.get(
        "/messages/conversations",
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      final List data = response.data;
      return data.map((e) => ChatModel.fromJson(e)).toList();
    } catch (e) {
      print("❌ fetchChats failed: $e");
      throw Exception('Failed to load chats');
    }
  }

  Future<List<SearchUserModel>> searchUsers(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final response = await _dio.get(
        "/auth/search",
        queryParameters: {"username": query},
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      final List data = response.data;
      return data.map((e) => SearchUserModel.fromJson(e)).toList();
    } catch (e) {
      print("❌ searchUsers failed: $e");
      return [];
    }
  }

  Future<List<MessageModel>> getConversation(String withUsername) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await _dio.get(
      "/messages/chats/$withUsername",
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );

    return (response.data as List)
        .map((e) => MessageModel.fromJson(e))
        .toList();
  }

  Future<bool> sendMessage(String toUsername, String content) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await _dio.post(
      "/messages/send",
      data: {
        "toUsername": toUsername,
        "content": content,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );

    return response.statusCode == 200;
  }
}
