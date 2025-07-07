import 'chat_user_info.dart'; 

class MessageModel {
  final UserInfoModel sender;
  final UserInfoModel receiver;
  final String content;
  final DateTime timestamp;

  MessageModel({
    required this.sender,
    required this.receiver,
    required this.content,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      sender: UserInfoModel.fromJson(json['sender']),
      receiver: UserInfoModel.fromJson(json['receiver']),
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
