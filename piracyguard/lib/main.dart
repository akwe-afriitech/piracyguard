import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:piracyguard/screens/homepage.dart';
import 'package:piracyguard/screens/licensetracking.dart';
import 'package:piracyguard/screens/generatelicense.dart';
import 'package:piracyguard/screens/reportgeneration.dart';
import 'package:piracyguard/screens/notification.dart';
import 'package:piracyguard/components/bottonNav.dart';
import 'package:piracyguard/screens/setting.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PiracyGuard',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(),
       initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/licenseTracking': (context) => LicenseTrackingPage(),
        '/generateLicense': (context) => GenerateLicenseScreen(),
        '/reportgenerationpage': (context) => const ReportGenerationPage(),
        '/notification': (context) => const NotificationPage(),
        '/settings': (context) =>  SettingScreen(),
        '/newLicense': (context) =>  GenerateLicenseScreen(),
        '/bottomNav': (context) => BottomNav(
          currentIndex: 0,
          onTap: (index) {
            // Handle bottom navigation tap
            if (index == 0) {
              Navigator.of(context).pushNamed('/');
            } else if (index == 1) {
              Navigator.of(context).pushNamed('/notification');
            } else if (index == 2) {
              Navigator.of(context).pushNamed('/settings');
            }
          },
        ),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

