import 'dart:ffi';

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
  Color _cardColor = Colors.white;
  String _remarks = "none";

  Future<void> _setCardColor() async {
    if (_airQuality != null) {
      final airQuality = await _airQuality;
      setState(() {
        _cardColor = _getColorFromAQI(airQuality!.airQualityIndex!);
      });
    }

    return; // Add a return statement here
  }

  Future<void> _setRemarks() async {
    if (_airQuality != null) {
      final airQuality = await _airQuality;
      setState(() {
        _remarks = _getRemarks(airQuality!.airQualityIndex!);
      });
    }

    return; // Add a return statement here
  }

  void _showLocationDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content:
              const Text('Please grant permission to access your location'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('Open Settings'),
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
          title: const Text("Location Permission"),
          content: const Text("We need your location to show air quality data"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Allow"),
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
    return Container(
      height: 300,
      child: Card(
        color: _cardColor,
        child: FutureBuilder<AirQuality>(
          future: _airQuality,
          builder: (BuildContext context, AsyncSnapshot<AirQuality> snapshot) {
            if (_airQuality == null ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Container(
                height: 300,
                child: const Center(child: CircularProgressIndicator()),
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final airQuality = snapshot.data!;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Air Quality Index:',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      ' ${airQuality.airQualityIndex}',
                      style: const TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),
                    Text(
                      '$_remarks',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Main Pollutant is ${airQuality.mainPollutant}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Time Recorded : ',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      ' ${airQuality.dateAndTime}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Text(
                    //   'Your Location:',
                    //   style: TextStyle(
                    //     fontSize: 10,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // Text(
                    //   'Latitude: ${_userPosition.latitude}',
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // Text(
                    //   'Longitude: ${_userPosition.longitude}',
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Color _getColorFromAQI(int aqi) {
    if (aqi <= 50) {
      return Colors.green;
    } else if (aqi <= 100) {
      return Colors.yellow;
    } else if (aqi <= 150) {
      return Colors.orange;
    } else if (aqi <= 200) {
      return Colors.red;
    } else if (aqi <= 300) {
      return Colors.purple;
    } else {
      return Colors.brown;
    }
  }

  String _getRemarks(int aqi) {
    if (aqi <= 50) {
      return 'Good';
    } else if (aqi <= 100) {
      return 'Moderate';
    } else if (aqi <= 150) {
      return 'Unhealthy for Sensitive Groups';
    } else if (aqi <= 200) {
      return 'Unhealthy';
    } else if (aqi <= 300) {
      return 'Very Unhealthy';
    } else {
      return 'Hazardous';
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    _setCardColor();
    _setRemarks();
    return airQualityCard();
  }
}
