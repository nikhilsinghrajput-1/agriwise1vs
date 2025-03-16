import 'package:myapp/src/features/home/domain/repositories/weather_repository.dart';

class GetWeatherData {
  final WeatherRepository repository;

  GetWeatherData({required this.repository});

  Future<Map<String, dynamic>> execute() async {
    return await repository.getWeatherData();
  }
}
