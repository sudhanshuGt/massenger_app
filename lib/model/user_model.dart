class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String bio;
  final String token;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.bio,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      username: json['username'],
      bio: json['bio'],
      token: json['token'],
    );
  }
}
