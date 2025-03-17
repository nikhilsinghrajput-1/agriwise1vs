import 'package:flutter/material.dart';

/// Model class for weather data
class WeatherModel {
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final int windDegree;
  final int clouds;
  final String description;
  final String icon;
  final String cityName;
  final String countryCode;
  final DateTime timestamp;
  
  const WeatherModel({
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.windDegree,
    required this.clouds,
    required this.description,
    required this.icon,
    required this.cityName,
    required this.countryCode,
    required this.timestamp,
  });
  
  /// Creates a WeatherModel from a JSON map
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['main']['temp'] as num).toDouble() - 273.15, // Convert from Kelvin to Celsius
      feelsLike: (json['main']['feels_like'] as num).toDouble() - 273.15,
      tempMin: (json['main']['temp_min'] as num).toDouble() - 273.15,
      tempMax: (json['main']['temp_max'] as num).toDouble() - 273.15,
      pressure: json['main']['pressure'] as int,
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      windDegree: json['wind']['deg'] as int,
      clouds: json['clouds']['all'] as int,
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
      cityName: json['name'] as String,
      countryCode: json['sys']['country'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
    );
  }
  
  /// Converts the WeatherModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'main': {
        'temp': temperature + 273.15, // Convert back to Kelvin
        'feels_like': feelsLike + 273.15,
        'temp_min': tempMin + 273.15,
        'temp_max': tempMax + 273.15,
        'pressure': pressure,
        'humidity': humidity,
      },
      'wind': {
        'speed': windSpeed,
        'deg': windDegree,
      },
      'clouds': {
        'all': clouds,
      },
      'weather': [
        {
          'description': description,
          'icon': icon,
        }
      ],
      'name': cityName,
      'sys': {
        'country': countryCode,
      },
      'dt': timestamp.millisecondsSinceEpoch ~/ 1000,
    };
  }
  
  /// Returns the URL for the weather icon
  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
  
  /// Returns the weather condition based on the description
  String get condition {
    if (description.contains('clear')) {
      return 'Clear';
    } else if (description.contains('cloud')) {
      return 'Cloudy';
    } else if (description.contains('rain') || description.contains('drizzle')) {
      return 'Rainy';
    } else if (description.contains('thunderstorm')) {
      return 'Thunderstorm';
    } else if (description.contains('snow')) {
      return 'Snowy';
    } else if (description.contains('mist') || description.contains('fog')) {
      return 'Foggy';
    } else {
      return 'Unknown';
    }
  }
  
  /// Returns the appropriate icon for the weather condition
  IconData get conditionIcon {
    switch (condition) {
      case 'Clear':
        return Icons.wb_sunny;
      case 'Cloudy':
        return Icons.cloud;
      case 'Rainy':
        return Icons.water_drop;
      case 'Thunderstorm':
        return Icons.flash_on;
      case 'Snowy':
        return Icons.ac_unit;
      case 'Foggy':
        return Icons.cloud;
      default:
        return Icons.wb_cloudy;
    }
  }
} 