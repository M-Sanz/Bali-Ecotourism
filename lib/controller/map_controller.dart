import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MyMapController extends GetxController {
  final mapController = MapController();
  final currentPosition = Rx<LatLng?>(null);
  final selectedLocation = Rxn<LatLng>();

  Future<void> centerToLocation(LatLng position) async {
    mapController.move(position, 100);
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Show dialog to ask user to enable location
        bool? enableService = await Get.dialog(
          AlertDialog(
            title: const Text('Location Service Disabled'),
            content: const Text('Please enable location services to continue'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Enable'),
              ),
            ],
          ),
        );

        if (enableService == true) {
          // Open location settings
          await Geolocator.openLocationSettings();
          // Re-check after returning from settings
          serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            Get.snackbar('Required', 'Location services must be enabled',
                snackPosition: SnackPosition.BOTTOM);
            return;
          }
        } else {
          return;
        }
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Permission Denied',
            'Location permissions are required to use this feature',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Required',
          'Location permissions are permanently denied. Please enable them in settings.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      final newPosition = LatLng(position.latitude, position.longitude);

      currentPosition.value = newPosition;
      mapController.move(newPosition, 15);
    } catch (e) {
      Get.snackbar(
        'Location Error',
        'Could not fetch current location: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void centerToSelectedLocation() {
    if (selectedLocation.value != null) {
      centerToLocation(selectedLocation.value!);
    }
  }

  @override
  void onClose() {
    mapController.dispose();
    super.onClose();
  }
}
