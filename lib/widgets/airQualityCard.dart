import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/air_quality.dart';

class AirQualityCard extends StatefulWidget {
  const AirQualityCard({Key? key}) : super(key: key);

  @override
  State<AirQualityCard> createState() => _AirQualityCardState();
}

class _AirQualityCardState extends State<AirQualityCard> {
  Future<AirQuality>? _airQuality;
  late Position _userPosition;

  void _showLocationDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission Required'),
          content: Text('Please grant permission to access your location'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => openAppSettings(),
              child: Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getUserLocation() async {
    if (await Permission.location.shouldShowRequestRationale) {
      // Show a dialog explaining why we need location permissions
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Location Permission"),
          content: Text("We need your location to show air quality data"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Allow"),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ).then((value) async {
        if (value == true) {
          // Request location permissions
          var status = await Permission.location.request();
          if (status == PermissionStatus.granted) {
            final position = await Geolocator.getCurrentPosition();
            setState(() {
              _userPosition = position;
              _airQuality = AirQuality().fetchAirQuality(
                _userPosition.latitude,
                _userPosition.longitude,
              );
            });
          }
        }
      });
    } else {
      // Request location permissions
      var status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        final position = await Geolocator.getCurrentPosition();
        setState(() {
          _userPosition = position;
          _airQuality = AirQuality().fetchAirQuality(
            _userPosition.latitude,
            _userPosition.longitude,
          );
        });
      }
    }
  }

  Widget airQualityCard() {
    return FutureBuilder<AirQuality>(
      future: _airQuality,
      builder: (BuildContext context, AsyncSnapshot<AirQuality> snapshot) {
        if (_airQuality == null ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final airQuality = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('City: ${airQuality.city}'),
                Text('Air Quality Index: ${airQuality.airQualityIndex}'),
                Text('Main Pollutant: ${airQuality.mainPollutant}'),
                Text('Date and Time: ${airQuality.dateAndTime}'),
                const SizedBox(height: 20),
                Text('Your Location:'),
                Text('Latitude: ${_userPosition.latitude}'),
                Text('Longitude: ${_userPosition.longitude}'),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return airQualityCard();
  }
}
