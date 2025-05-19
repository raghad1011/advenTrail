import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late GoogleMapController mapController;
  Marker? userMarker ;
  final LatLng _initialPosition  = const LatLng(31.9539, 35.9106);

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      startLocationUpdates();
    }
  }

  void startLocationUpdates() {
    Geolocator.getPositionStream().listen((Position position) {
      LatLng userPosition = LatLng(position.latitude, position.longitude);

      setState(() {
        userMarker = Marker(
          markerId: const MarkerId('user-location'),
          position: userPosition,
          infoWindow: const InfoWindow(title: 'My Location'),
        );
      });

      mapController?.animateCamera(
        CameraUpdate.newLatLng(userPosition),
      );
    });
  }


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Tracker"),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 15,
        ),
        markers: userMarker != null ? {userMarker!} : {},
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
