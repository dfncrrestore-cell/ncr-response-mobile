import 'package:flutter/material.dart';

class AiScanScreen extends StatelessWidget {
  static const routeName = '/ai-scan';

  const AiScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Scan')),
      body: const Center(
        child: Text('AI scan flow placeholder'),
      ),
    );
  }
}
