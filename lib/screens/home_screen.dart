import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../screens/notification_screen.dart';
import '../screens/newsfeed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/custom_font.dart';
import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'MukhangLibro';
      case 1:
        return 'Notifications';
      case 2:
        return widget.user.displayName;
      default:
        return 'MukhangLibro';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FB_DARK_PRIMARY,
        shadowColor: FB_PRIMARY,
        elevation: 2,
        title: CustomFont(
          text: _getAppBarTitle(),
          fontSize: ScreenUtil().setSp(25),
          color: FB_TEXT_COLOR_WHITE,
          fontFamily: 'Klavika',
        ),
        actions: _selectedIndex == 2
            ? [
                IconButton(
                  tooltip: 'Settings',
                  icon: const Icon(Icons.settings_outlined),
                  color: FB_TEXT_COLOR_WHITE,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SettingsScreen(user: widget.user),
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          NewsFeedScreen(user: widget.user),
          NotificationScreen(),
          ProfileScreen(user: widget.user),
        ],
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: FB_DARK_PRIMARY,
        showSelectedLabels: false, //selected item
        showUnselectedLabels: false, //unselected item
        onTap: _onTappedBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        unselectedItemColor: FB_TEXT_COLOR_WHITE,
        selectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }
}
