import 'package:myapp/src/core/repositories/base_repository.dart';
import 'package:myapp/src/features/weather/domain/models/weather_model.dart';

/// Interface for the weather repository
abstract class WeatherRepository {
  /// Gets the current weather for the specified city
  Future<Result<WeatherModel>> getCurrentWeather(String cityName);
} 