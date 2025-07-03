import 'package:flutter/material.dart';
import 'package:piracyguard/components/bottonNav.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildGridButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: onPressed ?? () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search license',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
            const SizedBox(height: 24),
            // Grid Buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildGridButton(
                    icon: Icons.track_changes,
                    label: 'License Tracking',
                    onPressed: () {
                      Navigator.pushNamed(context, '/licenseTracking');
                    },
                  ),
                  _buildGridButton(
                    icon: Icons.insert_chart,
                    label: 'Report Generation',
                    onPressed: () {
                      Navigator.pushNamed(context, '/reportgenerationpage');
                    },
                  ),
                  _buildGridButton(icon: Icons.code, label: 'Code Checks',
                      onPressed: () {
                        Navigator.pushNamed(context, '/codecheck');
                      }
                  ),
                  _buildGridButton(
                    icon: Icons.security,
                    label: 'Generate License',
                    onPressed: () {
                      Navigator.pushNamed(context, '/generateLicense');
                    },
                  ),
                  _buildGridButton(icon: Icons.settings, label: 'Settings'
                      , onPressed: () {
                        Navigator.pushNamed(context, '/settings');
                      }
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {},
                    child: const Icon(Icons.add, size: 32),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }
}
