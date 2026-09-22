class Comment {
  final int id;
  final int postId;
  final String body;
  final String username;
  final int userId;

  const Comment({
    required this.id,
    required this.postId,
    required this.body,
    required this.username,
    required this.userId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};
    return Comment(
      id: (json['id'] as num?)?.toInt() ?? 0,
      postId: (json['postId'] as num?)?.toInt() ?? 0,
      body: json['body'] as String? ?? '',
      username: user['username'] as String? ?? 'User',
      userId: (user['id'] as num?)?.toInt() ?? 0,
    );
  }
}
