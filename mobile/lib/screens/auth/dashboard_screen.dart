import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Wearable Dashboard'),
        elevation: 0, // Remove app bar shadow for a flatter look
        backgroundColor: Colors.teal, // Example color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Display two cards per row
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: const [
            DashboardCard(
                title: 'Health Report',
                icon: Icons.health_and_safety_outlined,
                imagePath:
                    'assets/images/health_report.jpg'), // Placeholder image path
            DashboardCard(
                title: 'Online Chat',
                icon: Icons.chat_bubble_outline,
                imagePath:
                    'assets/images/online_chat.jpg'), // Placeholder image path
            DashboardCard(
                title: 'Find Doctors',
                icon: Icons.medical_services_outlined,
                imagePath:
                    'assets/images/find_doctors.jpg'), // Placeholder image path
            DashboardCard(
                title: 'Pollution Tracker',
                icon: Icons.public_outlined,
                imagePath:
                    'assets/images/pollution_tracker.png'), // Placeholder image path
            DashboardCard(
                title: 'Log Symptom',
                icon: Icons.edit_note_outlined, // Or Icons.sick_outlined
                imagePath: 'assets/images/log_symptom.jpg'), // Placeholder image path
            DashboardCard(
                title: 'Emergency Plan',
                icon: Icons.assignment_late_outlined, // Or Icons.emergency_outlined
                imagePath: 'assets/images/emergency_plan.jpg'), // Placeholder image path
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? imagePath; // Added imagePath

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    this.imagePath, // Added to constructor
  });

  @override
  Widget build(BuildContext context) {
    Widget displayWidget;
    if (imagePath != null && imagePath!.isNotEmpty) {
      displayWidget = Image.asset(
        imagePath!,
        height: 48, // Adjust size as needed
        width: 48, // Adjust size as needed
        fit: BoxFit.cover,
      );
    } else {
      displayWidget = Icon(icon, size: 48, color: Colors.teal);
    }

    return Card(
      elevation: 4.0, // Add some shadow for depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      child: InkWell(
        // Make the card tappable with a ripple effect
        onTap: () {
          // Add navigation or functionality here
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title tapped!')),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              displayWidget, // Use the dynamic widget here
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600, // Bolder text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
