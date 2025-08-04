import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TripMapScreen(),
    );
  }
}

class Destination {
  final String name;
  final String description;
  final LatLng coordinates;

  const Destination({
    required this.name,
    required this.description,
    required this.coordinates,
  });
}

class TripMapScreen extends StatefulWidget {
  const TripMapScreen({super.key});

  @override
  State<TripMapScreen> createState() => _TripMapScreenState();
}

class _TripMapScreenState extends State<TripMapScreen> {
  final List<Destination> _destinations = [
    const Destination(
      name: 'London',
      description: 'Capital of England\nHome to Big Ben and Buckingham Palace',
      coordinates: LatLng(51.509364, -0.128928),
    ),
    const Destination(
      name: 'Paris',
      description: 'City of Love\nFamous for the Eiffel Tower',
      coordinates: LatLng(48.8566, 2.3522),
    ),
    const Destination(
      name: 'Rome',
      description: 'Eternal City\nHistoric Colosseum and Roman Forum',
      coordinates: LatLng(41.9028, 12.4964),
    ),
  ];

  Destination? _selectedDestination;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Destinations Map'),
        backgroundColor: Colors.blue[700],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(48.8566, 2.3522), // Paris as center
              initialZoom: 4.0,
              onTap: (_, __) => setState(() => _selectedDestination = null),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.tripmap',
              ),
              MarkerLayer(
                markers: _destinations
                    .map(
                      (destination) => Marker(
                        width: 40.0,
                        height: 40.0,
                        point: destination.coordinates,
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _selectedDestination = destination;
                          }),
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40.0,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          if (_selectedDestination != null)
            Positioned(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
              child: _LocationInfoCard(
                destination: _selectedDestination!,
                onClose: () => setState(() => _selectedDestination = null),
              ),
            ),
          const Positioned(
            bottom: 4.0,
            right: 4.0,
            child: _MapAttribution(),
          ),
        ],
      ),
    );
  }
}

class _LocationInfoCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback onClose;

  const _LocationInfoCard({
    required this.destination,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  destination.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                  color: Colors.grey[600],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              destination.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.blue[600],
                  size: 16.0,
                ),
                const SizedBox(width: 4.0),
                Text(
                  'Lat: ${destination.coordinates.latitude.toStringAsFixed(4)}, '
                  'Lng: ${destination.coordinates.longitude.toStringAsFixed(4)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MapAttribution extends StatelessWidget {
  const _MapAttribution();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () =>
            launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
        child: const Text(
          '© OpenStreetMap',
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

// Helper function to launch URLs (add this to a separate file in real app)
void launchUrl(Uri url) {
  // Implement URL launching logic using url_launcher package
  print('Would launch: $url');
}
