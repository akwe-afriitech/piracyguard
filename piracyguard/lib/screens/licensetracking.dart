import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../components/newlicense.dart';

class LicenseTrackingPage extends StatefulWidget {
  @override
  _LicenseTrackingPageState createState() => _LicenseTrackingPageState();
}

class _LicenseTrackingPageState extends State<LicenseTrackingPage>
    with TickerProviderStateMixin {
  int _selectedTab = 0;
  int _selectedBottomNav = 0;
  // Dummy data for demonstration

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

  Widget _buildLicenseTrackingTab() {
    Size size = MediaQuery.sizeOf(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('tracking').orderBy('createdAt').snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return const CircularProgressIndicator();
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            String profile = snapshot.data!.docs[index]['displayName'][0].toUpperCase();
            String displayName = snapshot.data!.docs[index]['displayName'];
            String license = snapshot.data!.docs[index]['license'];
            String uid = snapshot.data!.docs[index]['uid'];
            String type = snapshot.data!.docs[index]['type'];
            bool isVerified = snapshot.data!.docs[index]['isVerified'];
            bool isBlocked = snapshot.data!.docs[index]['isBlocked'];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text(profile),
                    ),
                    title: Text(displayName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('License: $license'),
                        Text(type, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    trailing: !isVerified
                        ? ElevatedButton(
                            onPressed: !isBlocked ?  () async{
                              await FirebaseFirestore.instance.collection('users').doc(uid).update({
                                    'isBlocked': true
                                  });
                            }:null,
                            style: ElevatedButton.styleFrom(backgroundColor: !isBlocked ?Colors.red : Colors.grey),
                            child: !isBlocked ? const Text('Block'):const Text('Blocked'),
                          )
                        : null,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0,horizontal: size.width*0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('STATUS : ',style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                            isVerified ? Text(' VERIFIED', style: TextStyle(fontSize: 12),)
                                :Text(' UNVERIFIED', style: TextStyle(fontSize: 12, color: Colors.grey),),
                          ],
                        ),
                        IconButton(
                            onPressed: (){
                              FirebaseFirestore.instance.collection('tracking').doc(uid).delete();
                            },
                            icon: Icon(Icons.delete, color: Colors.red,)
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      }
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