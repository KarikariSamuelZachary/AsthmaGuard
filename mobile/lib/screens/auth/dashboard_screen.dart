import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Wearable Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            DashboardCard(
                title: 'Health Report', icon: Icons.health_and_safety),
            DashboardCard(title: 'Online Chat', icon: Icons.chat),
            DashboardCard(title: 'Find Doctors', icon: Icons.local_hospital),
            DashboardCard(title: 'Pollution Tracker', icon: Icons.map),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Add navigation or functionality here
        },
      ),
    );
  }
}
