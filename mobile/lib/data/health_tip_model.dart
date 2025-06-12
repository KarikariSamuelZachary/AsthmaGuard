import 'package:flutter/material.dart'; // Ensures Icons is defined

// Defines the data structure for a health tip and asthma-specific categories.
class HealthTip {
  final String id;
  final String
      category; // e.g., 'trigger_avoidance', 'medication', 'breathing', 'emergency', 'lifestyle'
  final String title;
  final String description;
  final String type; // 'article', 'video', 'infographic'
  final String? imageUrl;
  final String? url; // Link to the full article/resource

  HealthTip({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.type,
    this.imageUrl,
    this.url,
  });
}

// Asthma-specific categories with associated icons and labels
final List<Map<String, dynamic>> asthmaTipCategories = [
  {
    'id': 'all',
    'icon': Icons.all_inclusive_outlined,
    'label': 'All'
  }, // Added 'All' category
  {
    'id': 'trigger_avoidance',
    'icon': Icons.no_encryption_gmailerrorred_outlined,
    'label': 'Triggers'
  }, // Placeholder, replace with appropriate icon
  {
    'id': 'medication',
    'icon': Icons.medication_outlined,
    'label': 'Medication'
  },
  {
    'id': 'breathing_exercises',
    'icon': Icons.self_improvement_outlined,
    'label': 'Breathing'
  },
  {
    'id': 'emergency_actions',
    'icon': Icons.emergency_outlined,
    'label': 'Emergency'
  },
  {
    'id': 'lifestyle',
    'icon': Icons.health_and_safety_outlined,
    'label': 'Lifestyle'
  },
];
