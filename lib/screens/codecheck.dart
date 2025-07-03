import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



// A data model to represent your user. This is much cleaner than using raw maps.
class AppUser {
  final String uid;
  final String displayName;
  final String license;
  final String type;
  final bool isVerified;
  bool isBlocked; // Mutable to allow state changes in the UI

  AppUser({
    required this.uid,
    required this.displayName,
    required this.license,
    required this.type,
    required this.isVerified,
    required this.isBlocked,
  });

  // Factory constructor to create a User from a Firestore document.
  // This is where we safely handle potentially missing data.
  factory AppUser.fromDoc(DocumentSnapshot doc) {
    // Cast the document's data to a Map. This is the crucial first step.
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return AppUser(
      uid: data['uid'] ?? doc.id, // Use doc.id as a fallback for uid
      displayName: data['displayName'] ?? 'No Name',
      license: data['license'] ?? 'No License',
      // THIS IS THE FIX: We access the map safely.
      type: data['type'] ?? 'Unknown Type',
      isVerified: data['isVerified'] ?? false,
      isBlocked: data['isBlocked'] ?? false,
    );
  }
}

class CodeCheckPage extends StatefulWidget {
  const CodeCheckPage({super.key});

  @override
  State<CodeCheckPage> createState() => _CodeCheckPageState();
}

class _CodeCheckPageState extends State<CodeCheckPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Check'),
        backgroundColor: const Color(0xFF1F2937),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          // Map the raw documents to our clean AppUser model
          final users = snapshot.data!.docs.map((doc) => AppUser.fromDoc(doc)).toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return UserCard(user: users[index]);
            },
          );
        },
      ),
    );
  }
}

class UserCard extends StatefulWidget {
  final AppUser user;

  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool _isChecking = false;

  // This simulates the "Check" functionality
  void _runCheck() async {
    setState(() {
      _isChecking = true;
    });

    // Simulate a 2-second check
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isChecking = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Check complete for ${widget.user.displayName}: App OK'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // This handles the blocking logic
  void _toggleBlock() async {
    bool newBlockStatus = !widget.user.isBlocked;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({'isBlocked': newBlockStatus});
      // The StreamBuilder will automatically rebuild the UI with the new status
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String profileInitial = widget.user.displayName.isNotEmpty ? widget.user.displayName[0].toUpperCase() : '?';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.indigo.shade100,
                child: Text(profileInitial, style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
              ),
              title: Text(widget.user.displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('License: ${widget.user.license}'),
              trailing: widget.user.isVerified
                  ? const Icon(Icons.verified, color: Colors.blue)
                  : const Icon(Icons.help_outline, color: Colors.orange),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('STATUS: ${widget.user.isVerified ? "VERIFIED" : "UNVERIFIED"}', style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text('TYPE: ${widget.user.type}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      // The "Check" button with loading state
                      SizedBox(
                        width: 100,
                        child: _isChecking
                            ? const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)))
                            : ElevatedButton(
                                onPressed: _runCheck,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: const Text('Check'),
                              ),
                      ),
                      const SizedBox(width: 8),
                      // The "Block/Unblock" button
                      ElevatedButton(
                        onPressed: _toggleBlock,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.user.isBlocked ? Colors.grey : Colors.red,
                        ),
                        child: Text(widget.user.isBlocked ? 'Unblock' : 'Block'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
