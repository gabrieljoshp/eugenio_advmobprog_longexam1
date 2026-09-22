import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/comment_service.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final User user;

  const PostCard({super.key, required this.post, required this.user});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final _commentController = TextEditingController();
  late Future<List<Comment>> _comments;
  late int _likes;
  bool _liked = false;
  bool _showComments = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.post.likes;
    _comments = CommentService().getCommentsForPost(widget.post.id);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    final body = _commentController.text.trim();
    if (body.isEmpty || _isSubmitting) return;
    setState(() => _isSubmitting = true);
    try {
      final comment = await CommentService().addComment(
        postId: widget.post.id,
        userId: widget.user.id,
        body: body,
      );
      if (!mounted) return;
      _commentController.clear();
      setState(() {
        _comments = _comments.then((comments) => [...comments, comment]);
        _showComments = true;
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not add comment.')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 4, 10, 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Post #${widget.post.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(widget.post.body, style: const TextStyle(fontSize: 16)),
            const Divider(height: 24),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => setState(() {
                    _liked = !_liked;
                    _likes += _liked ? 1 : -1;
                  }),
                  icon: Icon(
                    _liked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    color: _liked ? FB_DARK_PRIMARY : Colors.grey[700],
                  ),
                  label: Text('$_likes'),
                ),
                TextButton.icon(
                  onPressed: () =>
                      setState(() => _showComments = !_showComments),
                  icon: const Icon(Icons.comment_outlined),
                  label: const Text('Comments'),
                ),
              ],
            ),
            TextField(
              controller: _commentController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _addComment(),
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                suffixIcon: IconButton(
                  tooltip: 'Send comment',
                  onPressed: _addComment,
                  icon: _isSubmitting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                ),
              ),
            ),
            if (_showComments)
              FutureBuilder<List<Comment>>(
                future: _comments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: LinearProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text('Unable to load comments.'),
                    );
                  }
                  final comments = snapshot.data ?? [];
                  if (comments.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text('No comments yet.'),
                    );
                  }
                  return Column(
                    children: comments
                        .map(
                          (comment) => ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: const CircleAvatar(
                              radius: 15,
                              child: Icon(Icons.person, size: 16),
                            ),
                            title: Text(comment.username),
                            subtitle: Text(comment.body),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
