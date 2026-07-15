import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OfficeDashboardScreen extends StatelessWidget {
  static const routeName = '/office-dashboard';

  const OfficeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Office Dashboard')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('emergency_requests')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final requests = snapshot.data?.docs ?? [];
          if (requests.isEmpty) {
            return const Center(child: Text('No emergency requests have arrived yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final request = requests[index].data();
              final createdAt = request['createdAt'] as Timestamp?;
              final createdAtText = createdAt != null
                  ? DateTime.fromMillisecondsSinceEpoch(createdAt.seconds * 1000)
                      .toLocal()
                      .toString()
                  : 'Unknown time';

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request['name'] ?? 'Unknown customer',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text('Phone: ${request['phone'] ?? 'N/A'}'),
                      Text('Address: ${request['address'] ?? 'N/A'}'),
                      Text('Location: ${request['location'] ?? 'N/A'}'),
                      const SizedBox(height: 6),
                      Text('Status: ${request['status'] ?? 'pending'}'),
                      const SizedBox(height: 6),
                      Text('Requested: $createdAtText'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
