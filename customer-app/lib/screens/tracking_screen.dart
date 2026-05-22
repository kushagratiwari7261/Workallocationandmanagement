import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/socket.dart';
import '../core/theme.dart';
import 'package:lucide_icons/lucide_icons.dart';

class TrackingScreen extends StatefulWidget {
  final String bookingId;

  const TrackingScreen({super.key, required this.bookingId});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late GoogleMapController _mapController;
  LatLng _providerLocation = const LatLng(12.9716, 77.5946); // initial placeholder

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initSocketTracking();
  }

  Future<void> _initSocketTracking() async {
    final socket = await SocketService().getSocket();
    socket.emit('track:join', {'bookingId': widget.bookingId});

    SocketService().addListener('location:update', _onLocationUpdate);

    _updateMarkers();
  }

  void _onLocationUpdate(dynamic data) {
    if (data is Map && data['bookingId'] == widget.bookingId) {
      final double? lat = data['latitude'] != null ? (data['latitude'] as num).toDouble() : null;
      final double? lng = data['longitude'] != null ? (data['longitude'] as num).toDouble() : null;

      if (lat != null && lng != null) {
        setState(() {
          _providerLocation = LatLng(lat, lng);
          _updateMarkers();
        });
        _mapController.animateCamera(CameraUpdate.newLatLng(_providerLocation));
      }
    }
  }

  void _updateMarkers() {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('provider_marker'),
          position: _providerLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Ramesh (Cleaning Pro)'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _providerLocation,
              zoom: 15.0,
            ),
            markers: _markers,
            onMapCreated: (controller) => _mapController = controller,
          ),
          // Floating Back Button
          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(LucideIcons.arrowLeft, color: AppTheme.textMain),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          // Bottom Status Tracking Card
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(LucideIcons.clock, color: AppTheme.primary, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Arriving in 12 mins',
                        style: TextStyle(fontWeight: FontWeight.extrabold, fontSize: 15, color: AppTheme.textMain),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: AppTheme.border),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(LucideIcons.user, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ramesh Kumar',
                              style: TextStyle(fontWeight: FontWeight.extrabold, fontSize: 14, color: AppTheme.textMain),
                            ),
                            Text(
                              'Verified Cleaning Professional',
                              style: TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      // Call Button
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(LucideIcons.phone, color: AppTheme.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SocketService().removeListener('location:update', _onLocationUpdate);
    super.dispose();
  }
}
