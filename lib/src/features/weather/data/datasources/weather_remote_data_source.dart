import 'package:http/http.dart' as http;
import 'package:myapp/src/core/errors/exceptions.dart';
import 'package:myapp/src/core/network/api_client.dart';
import 'package:myapp/src/features/weather/domain/models/weather_model.dart';

/// Data source for fetching weather data from the remote API
class WeatherRemoteDataSource {
  final ApiClient _apiClient;
  final String _apiKey;
  
  WeatherRemoteDataSource({
    ApiClient? apiClient,
    String? apiKey,
  }) : _apiClient = apiClient ?? ApiClient(
         client: http.Client(),
         baseUrl: 'https://api.openweathermap.org/data/2.5',
       ),
       _apiKey = apiKey ?? 'YOUR_API_KEY'; // Replace with your actual API key
  
  /// Fetches weather data for the specified city
  Future<WeatherModel> getWeatherData(String cityName) async {
    try {
      final response = await _apiClient.get(
        '/weather?q=$cityName&appid=$_apiKey',
        useCache: true,
        cacheDuration: const Duration(hours: 1),
      );
      
      return WeatherModel.fromJson(response);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to fetch weather data: ${e.toString()}',
      );
    }
  }
  
  /// Fetches weather forecast for the specified city
  Future<List<WeatherModel>> getWeatherForecast(String cityName) async {
    try {
      final response = await _apiClient.get(
        '/forecast?q=$cityName&appid=$_apiKey',
        useCache: true,
        cacheDuration: const Duration(hours: 1),
      );
      
      final List<dynamic> forecastList = response['list'];
      return forecastList
          .map((item) => WeatherModel.fromJson({
                ...item,
                'name': cityName,
                'sys': {'country': response['city']['country']},
              }))
          .toList();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to fetch weather forecast: ${e.toString()}',
      );
    }
  }
} 