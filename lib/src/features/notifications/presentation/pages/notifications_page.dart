import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            child: ListTile(
              leading: Icon(notification.icon),
              title: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.readStatus ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              subtitle: Text(notification.message),
              trailing: Text(notification.timestamp),
              onTap: () {
                // TODO: Navigate to notification details
              },
            ),
          );
        },
      ),
    );
  }
}

class NotificationItem {
  final IconData icon;
  final String title;
  final String message;
  final String timestamp;
  final bool readStatus;

  NotificationItem({
    required this.icon,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.readStatus,
  });
}

final List<NotificationItem> notifications = [
  NotificationItem(
    icon: Icons.wb_sunny,
    title: 'Heavy Rain Warning',
    message: 'Heavy rain expected in your area in the next 24 hours.',
    timestamp: '2 hrs ago',
    readStatus: false,
  ),
  NotificationItem(
    icon: Icons.lightbulb,
    title: 'New AI Insight Available',
    message: 'A new AI insight is available for your tomato crop.',
    timestamp: '1 day ago',
    readStatus: true,
  ),
  NotificationItem(
    icon: Icons.system_update,
    title: 'System Maintenance Update',
    message: 'System maintenance will be performed on March 20th.',
    timestamp: '1 week ago',
    readStatus: true,
  ),
];
