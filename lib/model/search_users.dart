class SearchUserModel {
  final String username;
  final String firstName;
  final String lastName;
  final String bio;

  SearchUserModel({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.bio,
  });

  factory SearchUserModel.fromJson(Map<String, dynamic> json) {
    return SearchUserModel(
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      bio: json['bio'] ?? '',
    );
  }
}
