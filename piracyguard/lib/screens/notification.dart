import 'package:flutter/material.dart';
import 'package:piracyguard/components/bottonNav.dart';

class NotificationItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  NotificationItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Alert: License duplication',
      description:
          'We have detected a duplicate license usage. Please review your licenses.',
      icon: Icons.warning_amber_rounded,
      color: Colors.redAccent.shade100,
    ),
    NotificationItem(
      title: 'Your account settings are up to date',
      description:
          'All your account settings are current. No action is required.',
      icon: Icons.check_circle_outline,
      color: Colors.greenAccent.shade100,
    ),
    NotificationItem(
      title: 'Subscribe to the latest posts',
      description:
          'Stay updated by subscribing to our latest posts and announcements.',
      icon: Icons.notifications_active_outlined,
      color: Colors.blueAccent.shade100,
    ),
    NotificationItem(
      title: 'Scheduled maintenance for tomorrow',
      description:
          'The system will undergo scheduled maintenance tomorrow from 2 AM to 4 AM.',
      icon: Icons.build_circle_outlined,
      color: Colors.orangeAccent.shade100,
    ),
  ];

  List<bool> _expanded = [];

  @override
  void initState() {
    super.initState();
    _expanded = List.generate(notifications.length, (_) => false);
  }

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
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: notification.color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: notification.color.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ExpansionTile(
              leading: Icon(notification.icon, color: Colors.black87),
              title: Text(
                notification.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                _expanded[index]
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.black54,
              ),
              backgroundColor: notification.color,
              collapsedBackgroundColor: notification.color,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    notification.description,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ],
              onExpansionChanged: (expanded) {
                setState(() {
                  _expanded[index] = expanded;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action to perform when FAB is pressed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No new notifications')),
          );
        },
        child: const Icon(Icons.add_alert),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }
}
