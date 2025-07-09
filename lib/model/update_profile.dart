class UpdateProfileModel {
  final String? profile;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String bio;

  UpdateProfileModel({
    this.profile,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.bio,
  });

  Map<String, dynamic> toJson() => {
    "profile": profile,
    "email": email,
    "username": username,
    "firstName": firstName,
    "lastName": lastName,
    "bio": bio,
  };

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      profile: json['profile'],
      email: json['email'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      bio: json['bio'],
    );
  }
}
