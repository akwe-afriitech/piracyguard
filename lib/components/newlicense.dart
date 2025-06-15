import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewLicenseScreen extends StatefulWidget {
  @override
  _NewLicenseScreenState createState() => _NewLicenseScreenState();
}

class _NewLicenseScreenState extends State<NewLicenseScreen> {
  List<String> activeKeys = [
    'ABC123-DEF456-GHI789',
    'JKL012-MNO345-PQR678',
  ];
  List<String> expiredKeys = [
    'STU901-VWX234-YZA567',
  ];

  void _generateNewKey() {
    setState(() {
      activeKeys.add('NEWKEY-${DateTime.now().millisecondsSinceEpoch}');
    });
  }

  void _copyToClipboard(String key) {
    Clipboard.setData(ClipboardData(text: key));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Key copied to clipboard')),
    );
  }

  void _revokeKey(int index) {
    setState(() {
      expiredKeys.add(activeKeys[index]);
      activeKeys.removeAt(index);
    });
  }

  Widget _buildKeyRow(String key, VoidCallback onCopy, VoidCallback onRevoke) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: [
          Expanded(child: Text(key, style: const TextStyle(fontFamily: 'monospace'))),
          TextButton(onPressed: onCopy, child: const Text('Copy')),
          TextButton(onPressed: onRevoke, child: const Text('Revoke')),
        ],
      ),
    );
  }

  Widget _buildExpiredKeyRow(String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: [
          Expanded(child: Text(key, style: const TextStyle(fontFamily: 'monospace', color: Colors.grey))),
          TextButton(
            onPressed: () => _copyToClipboard(key),
            child: const Text('Copy'),
          ),
          const TextButton(
            onPressed: null,
            child: Text('Revoke', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _generateNewKey,
                child: const Text('Generate New Key'),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Active Keys', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          ...activeKeys.asMap().entries.map((entry) {
            int idx = entry.key;
            String key = entry.value;
            return _buildKeyRow(
              key,
              () => _copyToClipboard(key),
              () => _revokeKey(idx),
            );
          }).toList(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Expired Keys', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          ...expiredKeys.map((key) => _buildExpiredKeyRow(key)).toList(),
          const Spacer(),
        ],
      ),
    );
  }
}