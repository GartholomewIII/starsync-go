class UserModel {
  final String uid;
  final String email;
  final String bio;
  final String? profilePictureUrl;
  final String username;

  UserModel({required this.uid, required this.email, required this.bio, this.profilePictureUrl, required this.username});

  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      bio: data['bio'] ?? '',
      profilePictureUrl: data['profilePictureUrl'],
      username: data['username'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'bio': bio,
      'username': username,
      if (profilePictureUrl != null) 'profilePictureUrl': profilePictureUrl,
    };
  }
} 