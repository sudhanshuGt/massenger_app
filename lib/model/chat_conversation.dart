class ChatModel {
  final String username;
  final String firstName;
  final String lastName;
  final String bio;
  final String lastMessage;
  final DateTime timestamp;

  ChatModel({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.lastMessage,
    required this.timestamp,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      bio: json['bio'],
      lastMessage: json['lastMessage'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
