import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  final User? user;

  const SettingsScreen({super.key, this.user});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;

  Future<void> _signOut() async {
    await UserService().clearUser();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LogInScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: FB_DARK_PRIMARY,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          if (widget.user != null)
            ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: Text(widget.user!.displayName),
              subtitle: Text(widget.user!.email),
            ),
          const Divider(),
          SwitchListTile(
            value: _notifications,
            title: const Text('Notifications'),
            secondary: const Icon(Icons.notifications_outlined),
            onChanged: (value) => setState(() => _notifications = value),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sign out', style: TextStyle(color: Colors.red)),
            onTap: _signOut,
          ),
        ],
      ),
    );
  }
}
