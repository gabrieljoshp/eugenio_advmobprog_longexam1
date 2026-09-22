import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/custom_font.dart';
import '../widgets/post_card.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<Post>> _posts;

  @override
  void initState() {
    super.initState();
    _posts = PostService().getPostsByUser(widget.user.id);
  }

  Future<void> _refreshPosts() async {
    setState(() => _posts = PostService().getPostsByUser(widget.user.id));
    await _posts;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        color: Colors.white,
        child: RefreshIndicator(
          onRefresh: _refreshPosts,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _profileCover(),
                SizedBox(height: 55.h),
                _profileDetails(),
                SizedBox(height: 10.h),
                TabBar(
                  indicatorColor: FB_DARK_PRIMARY,
                  labelColor: FB_DARK_PRIMARY,
                  tabs: const [
                    Tab(text: 'Posts'),
                    Tab(text: 'About'),
                    Tab(text: 'Photos'),
                  ],
                ),
                SizedBox(
                  height: 500.h,
                  child: TabBarView(
                    children: [_postsTab(), _aboutTab(), _photosTab(context)],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileCover() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 200.h,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl:
                'https://base-prod.rspb-prod.magnolia-platform.com/.imaging/focalpoint/_WIDTH_x_HEIGHT_/dam/jcr:6b996ece-dc81-4bb7-88cd-1d0263d8b5d4/585246779-Species-Little-Owl-ADULT-Stood-on-fence-with-green-blurred-background.jpg',
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: CircularProgressIndicator(value: progress.progress),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.image),
          ),
        ),
        Positioned(
          bottom: -50,
          left: 20.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: widget.user.image.isEmpty
                    ? null
                    : NetworkImage(widget.user.image),
                child: widget.user.image.isEmpty
                    ? Text(
                        widget.user.displayName.characters.first.toUpperCase(),
                        style: const TextStyle(fontSize: 30),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _profileDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomFont(
            text: widget.user.displayName,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: Colors.black,
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              CustomFont(
                text: '0',
                fontSize: 15.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(width: 10.w),
              CustomFont(
                text: 'Followers',
                fontSize: 15.sp,
                color: Colors.grey,
              ),
              SizedBox(width: 8.w),
              const Icon(Icons.circle, size: 5, color: Colors.grey),
              SizedBox(width: 8.w),
              CustomFont(
                text: '0',
                fontSize: 15.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(width: 10.w),
              CustomFont(
                text: 'Following',
                fontSize: 15.sp,
                color: Colors.grey,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              CustomButton(buttonName: 'Follow', onPressed: () {}),
              SizedBox(width: 10.w),
              CustomButton(
                buttonName: 'Message',
                buttonType: 'outlined',
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _postsTab() {
    return FutureBuilder<List<Post>>(
      future: _posts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Unable to load your posts.'));
        }
        final posts = snapshot.data ?? [];
        if (posts.isEmpty) return const Center(child: Text('No posts yet.'));
        return ListView.builder(
          padding: EdgeInsets.only(top: 8.h),
          itemCount: posts.length,
          itemBuilder: (context, index) =>
              PostCard(post: posts[index], user: widget.user),
        );
      },
    );
  }

  Widget _aboutTab() {
    return ListView(
      padding: EdgeInsets.all(15.sp),
      children: [
        _aboutSection('Username', '@${widget.user.username}'),
        _aboutSection('Email', widget.user.email),
        _aboutSection('User ID', widget.user.id.toString()),
        _aboutSection('First name', widget.user.firstName),
        _aboutSection('Last name', widget.user.lastName),
      ],
    );
  }

  Widget _aboutSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomFont(
            text: title,
            fontSize: 14.sp,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 5.h),
          CustomFont(text: content, fontSize: 15.sp, color: Colors.black),
          SizedBox(height: 10.h),
          Container(height: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }

  Widget _photosTab(BuildContext context) {
    final photos = ['owl.jpg', 'owl2.jpg', 'owl3.jpg'];
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final path = 'assets/images/${photos[index]}';
        return GestureDetector(
          onTap: () =>
              CustomShowImageDialog(context, imageUrl: path, isAsset: true),
          child: Image.asset(path, fit: BoxFit.cover),
        );
      },
    );
  }
}
