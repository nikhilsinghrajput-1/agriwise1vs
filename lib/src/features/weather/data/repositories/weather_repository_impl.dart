import 'dart:convert';

import 'package:myapp/src/core/errors/exceptions.dart';
import 'package:myapp/src/core/network/connectivity_service.dart';
import 'package:myapp/src/core/repositories/base_repository.dart';
import 'package:myapp/src/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:myapp/src/features/weather/domain/models/weather_model.dart';
import 'package:myapp/src/features/weather/domain/repositories/weather_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherRepositoryImpl extends BaseRepository implements WeatherRepository {
  final WeatherRemoteDataSource _remoteDataSource;
  static const String _cacheKey = 'cached_weather_data';
  
  WeatherRepositoryImpl({
    required WeatherRemoteDataSource remoteDataSource,
    required super.connectivityService,
  }) : _remoteDataSource = remoteDataSource;
  
  @override
  Future<Result<WeatherModel>> getCurrentWeather(String cityName) async {
    return safeApiCallWithCache<WeatherModel>(
      apiCall: () => _remoteDataSource.getWeatherData(cityName),
      getCachedData: () => _getCachedWeatherData(),
      cacheData: (data) => _cacheWeatherData(data),
    );
  }
  
  /// Retrieves cached weather data
  Future<WeatherModel?> _getCachedWeatherData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);
      
      if (cachedData != null) {
        final decodedData = jsonDecode(cachedData);
        return WeatherModel.fromJson(decodedData);
      }
      
      return null;
    } catch (e) {
      throw CacheException(
        message: 'Failed to retrieve cached weather data: ${e.toString()}',
      );
    }
  }
  
  /// Caches weather data
  Future<void> _cacheWeatherData(WeatherModel data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedData = jsonEncode(data.toJson());
      await prefs.setString(_cacheKey, encodedData);
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache weather data: ${e.toString()}',
      );
    }
  }
} 