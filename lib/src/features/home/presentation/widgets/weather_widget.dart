import 'package:flutter/material.dart';
import 'package:myapp/src/features/home/data/datasources/weather_remote_data_source.dart';
import 'package:myapp/src/features/home/data/repositories/weather_repository_impl.dart';
import 'package:myapp/src/features/home/domain/usecases/get_weather_data.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherRemoteDataSource remoteDataSource = WeatherRemoteDataSource();
    final WeatherRepositoryImpl repository =
        WeatherRepositoryImpl(remoteDataSource: remoteDataSource);
    final GetWeatherData getWeatherData =
        GetWeatherData(repository: repository);
    final String cityName = remoteDataSource.cityName;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: getWeatherData.execute(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              // Extract relevant weather information from the data
              final temperatureKelvin = data['main']['temp'];
              final temperatureCelsius = temperatureKelvin - 273.15;
              final description = data['weather'][0]['description'];
              IconData weatherIcon;
              if (description.contains('cloud')) {
                weatherIcon = Icons.cloud;
              } else if (description.contains('rain')) {
                weatherIcon = Icons.water_drop;
              } else if (description.contains('sun')) {
                weatherIcon = Icons.sunny;
              } else {
                weatherIcon = Icons.wb_cloudy;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Weather',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(cityName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Icon(weatherIcon, color: Colors.orange),
                      const SizedBox(width: 5),
                      Text('Temperature: ${temperatureCelsius.toStringAsFixed(1)} °C',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text('Description: $description',
                      style: const TextStyle(fontStyle: FontStyle.italic)),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
