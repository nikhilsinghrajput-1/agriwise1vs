import 'package:myapp/src/core/repositories/base_repository.dart';
import 'package:myapp/src/features/weather/domain/models/weather_model.dart';
import 'package:myapp/src/features/weather/domain/repositories/weather_repository.dart';

/// Use case for getting weather data
class GetWeatherData {
  final WeatherRepository _repository;
  
  GetWeatherData({required WeatherRepository repository})
      : _repository = repository;
  
  /// Executes the use case to get weather data for the specified city
  Future<Result<WeatherModel>> execute(String cityName) async {
    return await _repository.getCurrentWeather(cityName);
  }
  
  /// Executes the use case to get weather data for the default city
  Future<Result<WeatherModel>> executeForDefaultCity() async {
    // Default city can be stored in user preferences or hardcoded
    const defaultCity = 'Pune'; // Replace with your default city
    return await _repository.getCurrentWeather(defaultCity);
  }
} 