class UserInfoModel {
  final String username;
  final String firstName;
  final String lastName;
  final String bio;

  UserInfoModel({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.bio,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      bio: json['bio'],
    );
  }
}
