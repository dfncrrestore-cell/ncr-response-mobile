import 'package:flutter/material.dart';
import 'emergency_request_screen.dart';
import 'ai_scan_screen.dart';
import 'job_status_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NCR Response')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, EmergencyRequestScreen.routeName);
              },
              child: const Text('Emergency Request'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AiScanScreen.routeName);
              },
              child: const Text('AI Scan'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, JobStatusScreen.routeName);
              },
              child: const Text('Job Status'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ProfileScreen.routeName);
              },
              child: const Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
