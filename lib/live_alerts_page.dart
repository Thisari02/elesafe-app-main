import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveAlertsPage extends StatelessWidget {
  const LiveAlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Firestore document path
    final alertDoc = FirebaseFirestore.instance
        .collection("Ele-Safe")
        .doc("vD7HsTUmIrY9MBskjOlQ"); // your document ID

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live IoT Alerts"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: alertDoc.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Title: ${data['title']}",
                    style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                Text("Description: ${data['description']}",
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),

                Text("Location: ${data['location']}",
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),

                Text("Timestamp: ${data['timestamp']}",
                    style: const TextStyle(fontSize: 16, color: Colors.black54)),
              ],
            ),
          );
        },
      ),
    );
  }
}
