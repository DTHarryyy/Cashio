class AppUser {
  final String userId;
  final String email;
  final String? username;
  final String? avatarUrl;

  AppUser({
    required this.userId,
    required this.email,
    this.username,
    this.avatarUrl,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      userId: map['user_id'],
      email: map['email'],
      username: map['username'] as String?,
      avatarUrl: map['avatar_url'] as String?,
    );
  }
}
