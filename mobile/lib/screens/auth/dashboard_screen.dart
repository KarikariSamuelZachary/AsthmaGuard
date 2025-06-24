import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentDate =
        DateFormat('MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('AsthmaGuard Dashboard'),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, currentDate),
              const SizedBox(height: 24.0),
              _buildQuickActions(context),
              const SizedBox(height: 24.0),
              Text(
                'Your Tools',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
              ),
              const SizedBox(height: 16.0),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  DashboardCard(
                    title: 'Health Tips', // Added Health Tips Card
                    icon: Icons.lightbulb_outline,
                    imagePath:
                        'assets/images/health_tips.png', // You may need to add an image asset for this
                    onTap: () {
                      Navigator.pushNamed(context, '/health-tips');
                    },
                  ),
                  DashboardCard(
                    title: 'Online Chat',
                    icon: Icons.chat_bubble_outline,
                    imagePath: 'assets/images/online_chat.jpg',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Navigate to Online Chat')),
                      );
                    },
                  ),
                  DashboardCard(
                    title: 'Log Symptom',
                    icon: Icons.edit_note_outlined,
                    imagePath: 'assets/images/log_symptom.jpg',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Log Symptom (from card) pressed!')),
                      );
                    },
                  ),
                  DashboardCard(
                    title: 'Emergency Plan',
                    icon: Icons.assignment_late_outlined,
                    imagePath: 'assets/images/emergency_plan.png',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Navigate to Emergency Plan')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String currentDate) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentDate,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade700,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Icon(Icons.wb_sunny_outlined,
                  color: Colors.orangeAccent.shade700, size: 20),
              const SizedBox(width: 8.0),
              Text(
                "Sunny, AQI: 35 (Good)",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            'Health Tip: Remember to take your controller medication as prescribed to prevent asthma attacks.',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade800,
              ),
        ),
        const SizedBox(height: 16.0),
        ElevatedButton.icon(
          icon: const Icon(Icons.edit_note_outlined, size: 20),
          label: const Text('Log Asthma Symptom'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            minimumSize: const Size(double.infinity, 50),
            elevation: 3,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Log Symptom button pressed!')),
            );
          },
        ),
      ],
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String imagePath;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 60,
              width: 60,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(icon, size: 40, color: Colors.teal.shade600);
              },
            ),
            const SizedBox(height: 10.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
