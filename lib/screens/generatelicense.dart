import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piracyguard/components/bottonNav.dart';
import '../components/newlicense.dart';

class GenerateLicenseScreen extends StatefulWidget {
  @override
  _GenerateLicenseScreenState createState() => _GenerateLicenseScreenState();
}

class _GenerateLicenseScreenState extends State<GenerateLicenseScreen> {
  
  int _selectedIndex = 0;

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate License'),
        centerTitle: true,
      ),
      body: NewLicenseScreen(),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }
}