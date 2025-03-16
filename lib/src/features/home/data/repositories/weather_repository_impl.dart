import 'package:myapp/src/features/home/data/datasources/weather_remote_data_source.dart';
import 'package:myapp/src/features/home/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> getWeatherData() async {
    return await remoteDataSource.getWeatherData();
  }
}
