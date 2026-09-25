import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/comment_service.dart';
import '../services/user_service.dart';
import '../screens/detail_screen.dart';

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
  late Future<User> _author;
  late int _likes;
  bool _liked = false;
  bool _showComments = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.post.likes;
    _comments = CommentService().getCommentsForPost(widget.post.id);
    _author = widget.post.userId == widget.user.id
        ? Future.value(widget.user)
        : UserService().getUserById(widget.post.userId);
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

  void _openDetails(User author) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          userName: author.displayName,
          postContent: widget.post.body,
          date: widget.post.createdAt,
          profileImageUrl: author.image,
          numOfLikes: _likes,
        ),
      ),
    );
  }

  Widget _buildAvatar(User author) {
    if (author.image.isEmpty) {
      return const Icon(Icons.person, size: 30);
    }

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: author.image,
        fit: BoxFit.cover,
        width: 30,
        height: 30,
        progressIndicatorBuilder: (context, url, progress) =>
            CircularProgressIndicator(
              color: FB_DARK_PRIMARY,
              value: progress.progress,
            ),
        errorWidget: (context, url, error) => const Icon(Icons.person),
      ),
    );
  }

  @override
  Widget _buildCard(User author) {
    return GestureDetector(
      onTap: () => _openDetails(author),
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.all(10.sp),
        child: Padding(
          padding: EdgeInsets.all(10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildAvatar(author),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        author.displayName,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.post.createdAt,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Icon(Icons.public, color: Colors.grey, size: 15.sp),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.more_horiz),
                ],
              ),
              SizedBox(height: 5.h),
              Text(
                widget.post.body,
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
              ),
              SizedBox(height: 5.h),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => setState(() {
                      _liked = !_liked;
                      _likes += _liked ? 1 : -1;
                    }),
                    icon: Icon(
                      _liked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      color: FB_DARK_PRIMARY,
                    ),
                    label: Text(
                      _likes == 0 ? 'Like' : '$_likes',
                      style: TextStyle(fontSize: 12.sp, color: FB_DARK_PRIMARY),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () =>
                        setState(() => _showComments = !_showComments),
                    icon: const Icon(Icons.comment, color: FB_DARK_PRIMARY),
                    label: Text(
                      'Comment',
                      style: TextStyle(fontSize: 12.sp, color: FB_DARK_PRIMARY),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.redo, color: FB_DARK_PRIMARY),
                    label: Text(
                      'Share',
                      style: TextStyle(fontSize: 12.sp, color: FB_DARK_PRIMARY),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildAvatar(widget.user),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Container(
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: TextField(
                        controller: _commentController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _addComment(),
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          hintStyle: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                          ),
                          border: InputBorder.none,
                          suffixIcon: _isSubmitting
                              ? const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : IconButton(
                                  tooltip: 'Send comment',
                                  onPressed: _addComment,
                                  icon: const Icon(Icons.send),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_showComments) _buildComments(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _author,
      builder: (context, snapshot) => _buildCard(snapshot.data ?? widget.user),
    );
  }

  Widget _buildComments() {
    return FutureBuilder<List<Comment>>(
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
    );
  }
}
