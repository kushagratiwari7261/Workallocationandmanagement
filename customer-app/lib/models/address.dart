import 'dart:math' as math;

class AddressModel {
  final String id;
  final String label;
  final String name;
  final String address;
  final String? landmark;
  final bool isDefault;
  final double? latitude;
  final double? longitude;

  AddressModel({
    required this.id,
    required this.label,
    required this.name,
    required this.address,
    this.landmark,
    required this.isDefault,
    this.latitude,
    this.longitude,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? '',
      label: json['label'] ?? 'Home',
      name: json['name'] ?? '',
      address: json['address'] ?? json['full_address'] ?? '',
      landmark: json['landmark'],
      isDefault: json['is_default'] ?? json['isDefault'] ?? false,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'name': name,
      'address': address,
      'landmark': landmark,
      'is_default': isDefault,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Mimics getDistanceFromLatLonInKm in addressStore.ts
  double distanceTo(double targetLat, double targetLng) {
    if (latitude == null || longitude == null) return double.infinity;

    const double r = 6371; // Earth's radius in KM
    final double dLat = (targetLat - latitude!) * (math.pi / 180);
    final double dLon = (targetLng - longitude!) * (math.pi / 180);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(latitude! * (math.pi / 180)) *
            math.cos(targetLat * (math.pi / 180)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }
}
