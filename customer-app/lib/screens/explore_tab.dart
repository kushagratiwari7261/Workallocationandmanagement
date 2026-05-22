import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/theme.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  late GoogleMapController _mapController;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(12.9716, 77.5946), // Bangalore coordinates default
    zoom: 14.0,
  );

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadProviderMarkers();
  }

  void _loadProviderMarkers() {
    setState(() {
      _markers.addAll([
        const Marker(
          markerId: MarkerId('p1'),
          position: LatLng(12.9725, 77.5937),
          infoWindow: InfoWindow(title: 'Ramesh - Cleaning Expert'),
        ),
        const Marker(
          markerId: MarkerId('p2'),
          position: LatLng(12.9705, 77.5955),
          infoWindow: InfoWindow(title: 'Suresh - Plumbing Professional'),
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) => _mapController = controller,
          ),
          // Top Search Bar
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(LucideIcons.search, color: AppTheme.textMuted, size: 20),
                  SizedBox(width: 12),
                  Text(
                    'Search for services or providers near you...',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Carousel of Nearby Providers
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.blueAccent,
                          child: Icon(LucideIcons.userCheck, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                index == 0 ? 'Ramesh Kumar' : 'Suresh Sharma',
                                style: const TextStyle(fontWeight: FontWeight.extrabold, fontSize: 14, color: AppTheme.textMain),
                              ),
                              Text(
                                index == 0 ? 'Home Cleaning • 4.8★' : 'Plumbing Setup • 4.9★',
                                style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(LucideIcons.messageSquare, color: AppTheme.primary),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
