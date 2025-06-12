import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PollutionZone {
  final String id;
  final LatLng coordinates;
  final String level;
  final double radius;
  final PollutionData data;

  PollutionZone({
    required this.id,
    required this.coordinates,
    required this.level,
    required this.radius,
    required this.data,
  });
}

class PollutionData {
  final int aqi;
  final double pm25;
  final double pm10;

  PollutionData({
    required this.aqi,
    required this.pm25,
    required this.pm10,
  });
}

class PollutionTrackerScreen extends StatefulWidget {
  const PollutionTrackerScreen({super.key});

  @override
  State<PollutionTrackerScreen> createState() => _PollutionTrackerScreenState();
}

class _PollutionTrackerScreenState extends State<PollutionTrackerScreen> {
  PollutionZone? selectedZone;
  // Ensure flutter_dotenv is initialized, typically in main.dart
  // await dotenv.load(fileName: ".env");
  final accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'];

  @override
  void initState() {
    super.initState();
    _validateAccessToken();
  }

  void _validateAccessToken() {
    if (accessToken == null || accessToken!.isEmpty) {
      // It's better to handle this gracefully, e.g., show a message to the user
      // or disable map functionality. Throwing an exception might crash the app.
      debugPrint(
          'MAPBOX_ACCESS_TOKEN is not available. Please check your .env file and ensure it is loaded.');
      // Consider showing a dialog or a placeholder widget if the token is missing.
    }
  }

  // Mock data for pollution zones
  final List<PollutionZone> pollutionZones = [
    PollutionZone(
      id: '1',
      coordinates:
          const LatLng(40.6935, -73.9866), // Example: Downtown Brooklyn
      level: 'high',
      radius: 500, // meters
      data: PollutionData(aqi: 156, pm25: 75.2, pm10: 142.8),
    ),
    PollutionZone(
      id: '2',
      coordinates:
          const LatLng(40.6895, -73.9845), // Example: Near Brooklyn Bridge Park
      level: 'medium',
      radius: 300, // meters
      data: PollutionData(aqi: 89, pm25: 35.5, pm10: 82.3),
    ),
    PollutionZone(
      id: '3',
      coordinates:
          const LatLng(40.6915, -73.9825), // Example: Another nearby location
      level: 'low',
      radius: 400, // meters
      data: PollutionData(aqi: 42, pm25: 12.8, pm10: 38.5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (accessToken == null || accessToken!.isEmpty) {
      // Show a message if the access token is missing
      return Scaffold(
        appBar: AppBar(title: const Text('Pollution Tracker')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Mapbox Access Token is missing. Please configure it in your .env file to use the map feature.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pollution Tracker',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4285F4), // Google Blue, for example
              ),
        ),
        // backgroundColor: isDark ? Colors.grey[850] : Colors.white,
        // elevation: 1,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: pollutionZones.isNotEmpty
                  ? pollutionZones[0].coordinates
                  : const LatLng(
                      40.7128, -74.0060), // Default to NYC if no zones
              initialZoom: 13,
              onTap: (tapPosition, point) {
                setState(() => selectedZone = null);
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/mapbox/${isDark ? 'dark' : 'light'}-v10/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',
                additionalOptions: {
                  'accessToken': accessToken!,
                },
              ),
              CircleLayer(
                circles: pollutionZones
                    .map((zone) => CircleMarker(
                          point: zone.coordinates,
                          radius: zone.radius, // Use actual radius in meters
                          color:
                              _getPollutionColor(zone.level).withOpacity(0.5),
                          useRadiusInMeter: true,
                          borderStrokeWidth: 1,
                          borderColor: _getPollutionColor(zone.level),
                        ))
                    .toList(),
              ),
              MarkerLayer(
                markers: pollutionZones
                    .map((zone) => Marker(
                          point: zone.coordinates,
                          width: 40, // Fixed size for tap target
                          height: 40,
                          child: GestureDetector(
                            onTap: () => setState(() => selectedZone = zone),
                            child: Container(
                              // Optionally, make the tap target visible for debugging
                              // color: Colors.transparent.withOpacity(0.3),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Colors.transparent, // Invisible tap target
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
          // Legend Card
          Positioned(
            left: 16,
            bottom: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: isDark ? Colors.white70 : Colors.black87,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Pollution Levels',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildLegendItem(
                      color: Colors.red,
                      label: 'High',
                      description: 'AQI > 150',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 6),
                    _buildLegendItem(
                      color: Colors.orange,
                      label: 'Medium',
                      description: 'AQI 51-150',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 6),
                    _buildLegendItem(
                      color: Colors.green,
                      label: 'Low',
                      description: 'AQI 0-50',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Pollution Info Card
          if (selectedZone != null)
            Positioned(
              top: 16,
              right: 16,
              left: 16, // Allow card to take more width if needed
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Zone Details: ${selectedZone!.id}', // Display zone ID or name
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceAround, // Better spacing for data items
                        children: [
                          _buildDataItem(
                              'AQI', selectedZone!.data.aqi.toString(), isDark),
                          _buildDataItem(
                              'PM2.5',
                              selectedZone!.data.pm25.toStringAsFixed(1),
                              isDark), // Format double
                          _buildDataItem(
                              'PM10',
                              selectedZone!.data.pm10.toStringAsFixed(1),
                              isDark), // Format double
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: const Text('Close'),
                          onPressed: () => setState(() => selectedZone = null),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String description,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            // border: Border.all(color: isDark ? Colors.white30 : Colors.black12)
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataItem(String label, String value, bool isDark) {
    return Column(
      // Changed to Column for better layout of label and value
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18, // Larger value text
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  Color _getPollutionColor(String level) {
    switch (level.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.orangeAccent;
      case 'low':
        return Colors.greenAccent;
      default:
        return Colors.grey; // Default color for unknown levels
    }
  }
}
