import 'dart:convert';
import 'package:http/http.dart' as http;

class AirQuality {
  final String? city;
  final String? airQualityIndex;
  final String? mainPollutant;
  final String? dateAndTime;

  AirQuality({
    this.city,
    this.airQualityIndex,
    this.mainPollutant,
    this.dateAndTime,
  });

  AirQuality.fromJSON(Map<String, dynamic> json)
      : city = json['city']['name'],
        airQualityIndex = json['aqi'].toString(),
        mainPollutant = json['dominentpol'],
        dateAndTime = json['time']['s'];

  Future<AirQuality> fetchAirQuality(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.waqi.info/feed/geo:$latitude;$longitude/?token=662754ca59f0f71509a907c517ea9ea5e0b10791'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final airQuality = AirQuality.fromJSON(json['data']);
      return airQuality;
    } else {
      throw Exception('Failed to load air quality');
    }
  }
}
