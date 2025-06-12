import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/data/health_report_data.dart'; // Adjusted import path

class HealthReportModal extends StatelessWidget {
  final Map<String, dynamic> userData;

  const HealthReportModal({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final report = generateHealthReport(
        userData); // This will use the placeholder function

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Health Report',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close,
                      color: isDark ? Colors.white70 : Colors.black54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            _buildReportHeader(report['userInfo'], isDark),
            const SizedBox(height: 24),
            _buildVitalsSection(report['vitals'], isDark),
            const SizedBox(height: 24),
            _buildEnvironmentalMetrics(report['environmentalMetrics'], isDark),
            const SizedBox(height: 24),
            _buildRecommendations(report['recommendations'], isDark),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                      foregroundColor:
                          isDark ? Colors.blue.shade300 : Colors.blue.shade700),
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Download PDF'),
                  onPressed: () {
                    // TODO: Implement PDF download
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('PDF Download not implemented yet.')),
                    );
                  },
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  style: TextButton.styleFrom(
                      foregroundColor:
                          isDark ? Colors.blue.shade300 : Colors.blue.shade700),
                  icon: const Icon(Icons.share_outlined),
                  label: const Text('Share'),
                  onPressed: () {
                    // TODO: Implement share functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Share feature not implemented yet.')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportHeader(Map<String, dynamic> userInfo, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252525) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Report ID: ${userInfo['reportId']}',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            // Safely format date
            'Date: ${userInfo['date'] != null ? DateFormat('MMM d, yyyy HH:mm').format(DateTime.parse(userInfo['date'])) : 'N/A'}',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Patient: ${userInfo['name'] ?? 'N/A'}',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsSection(Map<String, dynamic> vitals, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vital Statistics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: vitals.entries.map((entry) {
            final data = entry.value as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildMetricCard(
                title: data['displayName'] ??
                    entry.key, // Use display name if available
                value: data['average']?.toString() ?? 'N/A',
                status: data['status']?.toString() ?? 'Unknown',
                details: {
                  'Min': data['min']?.toString() ?? 'N/A',
                  'Max': data['max']?.toString() ?? 'N/A',
                },
                isDark: isDark,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEnvironmentalMetrics(Map<String, dynamic> metrics, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Environmental Metrics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ...metrics.entries.map((entry) {
          final data = entry.value as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildMetricRow(
              title: data['displayName'] ?? entry.key, // Use display name
              value: data['average']?.toString() ?? 'N/A',
              status: data['status']?.toString() ?? 'Unknown',
              isDark: isDark,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRecommendations(List<dynamic> recommendations, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        if (recommendations.isEmpty)
          Text(
            'No specific recommendations at this time. Maintain current habits.',
            style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
          )
        else
          ...recommendations.map((rec) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: isDark
                          ? Colors.green.shade300
                          : Colors.green.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rec.toString(),
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String status,
    required bool isDark,
    Map<String, String>? details,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252525) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 8, // Softer shadow
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          if (details != null && details.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: details.entries
                  .map((e) => Expanded(
                        child: Row(
                          children: [
                            Text(
                              '${e.key}: ',
                              style: TextStyle(
                                color:
                                    isDark ? Colors.white60 : Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              e.value,
                              style: TextStyle(
                                color:
                                    isDark ? Colors.white70 : Colors.grey[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5), // Adjusted padding
            decoration: BoxDecoration(
              color: _getStatusColor(status, isDark),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow({
    required String title,
    required String value,
    required String status,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 12), // Adjusted padding
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252525) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            // Allow text to wrap if needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16), // Add spacing
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _getStatusColor(status, isDark),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status, bool isDark) {
    // Enhanced status colors for better theming
    switch (status.toLowerCase()) {
      case 'normal':
      case 'good':
      case 'stable':
        return isDark ? Colors.green.shade400 : Colors.green.shade600;
      case 'moderate':
      case 'attention':
        return isDark ? Colors.orange.shade400 : Colors.orange.shade600;
      case 'high':
      case 'poor':
      case 'critical':
        return isDark ? Colors.red.shade400 : Colors.red.shade600;
      case 'active':
        return isDark ? Colors.blue.shade300 : Colors.blue.shade600;
      default:
        return Colors.grey.shade500;
    }
  }
}
