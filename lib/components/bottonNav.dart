import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          label: 'Dashboard',
          icon: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/');
            },
            child: Icon(Icons.dashboard),
          ),
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/notification');
            },
            child: Icon(Icons.notifications),
          ),
          label: 'Notification',
        ),
        BottomNavigationBarItem(
          label: 'Settings', // Add a label here
          icon: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/settings');
            },
            child: Icon(Icons.settings),
          ),
        ),
      ],
    );
  }
}
