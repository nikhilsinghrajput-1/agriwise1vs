import 'package:flutter/material.dart';

class OfflineModePage extends StatelessWidget {
  const OfflineModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Mode'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last Synced Data Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Last Synced Data',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Last Synced: 10:30 AM, 25-Apr-2024'),
                    const SizedBox(height: 8),
                    const Text('Weather, advisory, and sensor data'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Manual Sync Option
            ElevatedButton(
              onPressed: () {
                // TODO: Implement manual sync functionality
              },
              child: const Text('Sync Now'),
            ),
            const SizedBox(height: 16),

            // Offline Notice
            const Text(
              'No internet connection. Displaying last available data.',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
