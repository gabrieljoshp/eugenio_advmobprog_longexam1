import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/comment.dart';

class CommentService {
  Future<List<Comment>> getCommentsForPost(int postId) async {
    final response = await http.get(Uri.parse('$host/comments/post/$postId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load comments');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['comments'] as List<dynamic>? ?? [])
        .map((item) => Comment.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Comment> addComment({
    required int postId,
    required int userId,
    required String body,
  }) async {
    final response = await http.post(
      Uri.parse('$host/comments/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'body': body, 'postId': postId, 'userId': userId}),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to add comment');
    }
    return Comment.fromJson(jsonDecode(response.body));
  }
}
