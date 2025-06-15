import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'generatelicense.dart';
import '../components/newlicense.dart';

class LicenseTrackingPage extends StatefulWidget {
  @override
  _LicenseTrackingPageState createState() => _LicenseTrackingPageState();
}

class _LicenseTrackingPageState extends State<LicenseTrackingPage>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  int _selectedBottomNav = 0;
  // Dummy data for demonstration
  List<Map<String, String>> clients = [
    {
      'username': 'john_doe',
      'uid': 'UID12345',
      'license': 'LIC-ABC-123',
      'duplicated': 'false',
    },
    {
      'username': 'jane_smith',
      'uid': 'UID67890',
      'license': 'LIC-XYZ-789',
      'duplicated': 'true',
    },
    {
      'username': 'alice_wonder',
      'uid': 'UID54321',
      'license': 'LIC-DEF-456',
      'duplicated': 'false',
    },
  ];

  // Dummy data for statistics
  List<FlSpot> licenseStats = [
    const FlSpot(1, 2),
    const FlSpot(2, 4),
    const FlSpot(3, 6),
    const FlSpot(4, 8),
    const FlSpot(5, 10),
    const FlSpot(6, 7),
    const FlSpot(7, 12),
  ];

  void _blockUser(int index) {
    setState(() {
      clients[index]['blocked'] = 'true';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${clients[index]['username']} has been blocked.')),
    );
  }

  Widget _buildLicenseTrackingTab() {
    return ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context, index) {
        final client = clients[index];
        final isDuplicated = client['duplicated'] == 'true';
        final isBlocked = client['blocked'] == 'true';
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(client['username']![0].toUpperCase()),
            ),
            title: Text(client['username']!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('UID: ${client['uid']}'),
                Text('License: ${client['license']}'),
                if (isDuplicated)
                  const Text(
                    'Duplicated License!',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                if (isBlocked)
                  const Text(
                    'Blocked',
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
            trailing: isDuplicated && !isBlocked
                ? ElevatedButton(
                    onPressed: () => _blockUser(index),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Block'),
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildStatisticsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: licenseStats,
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildLicenseTrackingTab();
      case 1:
        return _buildStatisticsTab();
      case 2:
        return NewLicenseScreen();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('License Tracking'),
        bottom: TabBar(
          controller: TabController(length: 3, vsync: this, initialIndex: _selectedTab),
          onTap: (index) => setState(() => _selectedTab = index),
          tabs: [
            const Tab(text: 'Tracking'),
            const Tab(text: 'Statistics'),
            const Tab(text: 'Generate'),
          ],
        ),
      ),
      body: _buildTabContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNav,
        onTap: (index) => setState(() => _selectedBottomNav = index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}