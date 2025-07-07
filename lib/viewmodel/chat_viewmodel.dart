import 'dart:async';
import 'package:flutter/material.dart';

import '../model/chat_conversation.dart';
import '../model/chat_message.dart';
import '../model/search_users.dart';
import '../repository/chat_convo_repository.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatService _chatService = ChatService();

  List<ChatModel> chats = [];
  List<SearchUserModel> searchResults = [];
  List<MessageModel> messages = [];

  bool isLoading = false;
  bool isSearching = false;

  Timer? _pollingTimer;
  String? _currentUserForPolling;
  List<String> _lastMessageHashes = [];

  void startPolling(String username) {
    _currentUserForPolling = username;
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _loadAndCompareConversation();
    });
    _loadAndCompareConversation();
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _currentUserForPolling = null;
  }

  Future<void> _loadAndCompareConversation() async {
    if (_currentUserForPolling == null) return;

    try {
      final newMessages = await _chatService.getConversation(_currentUserForPolling!);
      final newHashes = newMessages.map(_hash).toList();

      if (!_areListsEqual(_lastMessageHashes, newHashes)) {
        messages = newMessages;
        _lastMessageHashes = newHashes;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Polling error: $e");
    }
  }

  String _hash(MessageModel m) => '${m.sender.username}:${m.content}:${m.timestamp}';

  bool _areListsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Future<void> loadConversation(String username) async {
    notifyListeners();

    try {
      messages = await _chatService.getConversation(username);
      _lastMessageHashes = messages.map(_hash).toList();
    } catch (_) {
      messages = [];
    }

    notifyListeners();
  }

  Future<void> sendMessage(String toUsername, String content) async {
    final success = await _chatService.sendMessage(toUsername, content);
    if (success) {
      await loadConversation(toUsername);
    }
  }

  Future<void> loadChats() async {
    isLoading = true;
    notifyListeners();

    try {
      chats = await _chatService.fetchChats();
    } catch (e) {
      chats = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> searchUsers(String query) async {
    if (query.length < 3) {
      searchResults = [];
      isSearching = false;
      notifyListeners();
      return;
    }

    isSearching = true;
    notifyListeners();

    try {
      searchResults = await _chatService.searchUsers(query);
    } catch (_) {
      searchResults = [];
    }

    isSearching = false;
    notifyListeners();
  }
}
