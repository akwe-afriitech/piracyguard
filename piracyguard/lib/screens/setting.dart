import 'package:flutter/material.dart';
import 'package:piracyguard/components/bottonNav.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int _selectedIndex = 2;

  Widget _buildSettingRow(
      BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSettingRow(context, 'Manage Account', () {
            // Navigate to Manage Account
          }),
          _buildSettingRow(context, 'Notifications', () {
            // Navigate to Notifications
          }),
          _buildSettingRow(context, 'Preferences', () {
            // Navigate to Preferences
          }),
          _buildSettingRow(context, 'Help and Support', () {
            // Navigate to Help and Support
          }),
          _buildSettingRow(context, 'About', () {
            // Navigate to About
          }),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }
}
