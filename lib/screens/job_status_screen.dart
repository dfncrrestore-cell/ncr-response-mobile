import 'package:flutter/material.dart';

class JobStatusScreen extends StatelessWidget {
  static const routeName = '/job-status';

  const JobStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Status')),
      body: const Center(
        child: Text('Job status tracking placeholder'),
      ),
    );
  }
}
