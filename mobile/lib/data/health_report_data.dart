// Placeholder for health_report_data.dart
// You need to implement the actual data generation logic here.

// Example structure for the data returned by generateHealthReport
Map<String, dynamic> generateHealthReport(Map<String, dynamic> userData) {
  // Replace with your actual data fetching and processing logic
  final now = DateTime.now();
  final reportId =
      'HR-${now.year}${now.month}${now.day}-${userData['id']?.substring(0, 4) ?? 'xxxx'}';

  return {
    'userInfo': {
      'reportId': reportId,
      'date': now.toIso8601String(),
      'name': userData['name'] ?? 'N/A',
      // Add other user details as needed
    },
    'vitals': {
      'Heart Rate': {
        'displayName': 'Heart Rate',
        'average': '75 bpm',
        'min': '60 bpm',
        'max': '100 bpm',
        'status': 'Normal',
      },
      'SpO2': {
        'displayName': 'Oxygen Saturation (SpO2)',
        'average': '98%',
        'min': '95%',
        'max': '100%',
        'status': 'Good',
      },
      'Temperature': {
        'displayName': 'Body Temperature',
        'average': '36.5 °C',
        'min': '36.0 °C',
        'max': '37.0 °C',
        'status': 'Stable',
      },
      'Peak Flow': {
        'displayName': 'Peak Expiratory Flow (PEF)',
        'average': '450 L/min',
        'min': '400 L/min',
        'max': '500 L/min',
        'status': 'Good',
      }
    },
    'environmentalMetrics': {
      'Air Quality Index (AQI)': {
        'displayName': 'Air Quality Index (AQI)',
        'average': '45',
        'status': 'Good',
      },
      'Pollen Count': {
        'displayName': 'Pollen Count',
        'average': 'Low',
        'status': 'Good',
      },
      'Humidity': {
        'displayName': 'Ambient Humidity',
        'average': '55%',
        'status': 'Moderate',
      },
    },
    'recommendations': [
      'Continue monitoring symptoms daily.',
      'Ensure reliever inhaler is accessible at all times.',
      'Consider discussing PEF readings with your doctor if consistently below 420 L/min.',
      'Stay hydrated, drink plenty of water.',
    ],
  };
}
