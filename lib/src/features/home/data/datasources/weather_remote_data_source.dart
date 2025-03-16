import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherRemoteDataSource {
  final String apiKey = '122b5ca44232667e09aac00898f601bf';
  final String cityName = 'Dhaka';

  Future<Map<String, dynamic>> getWeatherData() async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
