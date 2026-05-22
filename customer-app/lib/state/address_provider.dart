import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/address.dart';
import '../core/storage.dart';

class AddressState {
  final AddressModel? selectedAddress;
  final String rawLocationName;
  final List<AddressModel> savedAddresses;

  AddressState({
    this.selectedAddress,
    this.rawLocationName = 'Detecting location...',
    this.savedAddresses = const [],
  });

  AddressState copyWith({
    AddressModel? selectedAddress,
    String? rawLocationName,
    List<AddressModel>? savedAddresses,
  }) {
    return AddressState(
      selectedAddress: selectedAddress ?? this.selectedAddress,
      rawLocationName: rawLocationName ?? this.rawLocationName,
      savedAddresses: savedAddresses ?? this.savedAddresses,
    );
  }
}

class AddressNotifier extends StateNotifier<AddressState> {
  AddressNotifier() : super(AddressState()) {
    _loadFromCache();
  }

  static const String _storageKey = 'workla-address-storage';

  void _loadFromCache() {
    final cached = LocalCache.get<String>(_storageKey);
    if (cached != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(cached);
        final selectedJson = data['selectedAddress'];
        state = AddressState(
          selectedAddress: selectedJson != null ? AddressModel.fromJson(selectedJson) : null,
          rawLocationName: data['rawLocationName'] ?? 'Please select location',
        );
      } catch (_) {}
    }
  }

  void _saveToCache() {
    final data = {
      'selectedAddress': state.selectedAddress?.toJson(),
      'rawLocationName': state.rawLocationName,
    };
    LocalCache.set(_storageKey, jsonEncode(data));
  }

  void setSelectedAddress(AddressModel? address) {
    state = state.copyWith(selectedAddress: address);
    _saveToCache();
  }

  void setRawLocationName(String name) {
    state = state.copyWith(rawLocationName: name);
    _saveToCache();
  }

  void setSavedAddresses(List<AddressModel> addresses) {
    state = state.copyWith(savedAddresses: addresses);
  }

  Future<void> autoDetectAddress(double lat, double lng) async {
    if (state.savedAddresses.isEmpty) return;

    AddressModel? closestAddress;
    double shortestDistance = double.infinity;

    for (final addr in state.savedAddresses) {
      final d = addr.distanceTo(lat, lng);
      if (d < shortestDistance) {
        shortestDistance = d;
        closestAddress = addr;
      }
    }

    // Auto-switch matching the React Native threshold (150 meters)
    if (closestAddress != null && shortestDistance <= 0.15) {
      final current = state.selectedAddress;
      if (current == null || (closestAddress.isDefault && current.id != closestAddress.id)) {
        state = state.copyWith(selectedAddress: closestAddress);
        _saveToCache();
      }
    } else {
      if (state.selectedAddress == null) {
        final def = state.savedAddresses.firstWhere((a) => a.isDefault, orElse: () => state.savedAddresses.first);
        state = state.copyWith(selectedAddress: def);
        _saveToCache();
      }
    }
  }

  Future<void> requestLocationAndDetect() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        final Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        );
        
        await autoDetectAddress(pos.latitude, pos.longitude);

        final List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
        if (placemarks.isNotEmpty) {
          final String city = placemarks.first.locality ?? placemarks.first.subAdministrativeArea ?? 'Unknown City';
          setRawLocationName(city);
        }
      }
    } catch (_) {}
  }
}

final addressProvider = StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  return AddressNotifier();
});
