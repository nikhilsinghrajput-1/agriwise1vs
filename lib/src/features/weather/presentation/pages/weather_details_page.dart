import 'package:flutter/material.dart';
import 'package:myapp/src/features/home/data/datasources/weather_remote_data_source.dart';
import 'package:myapp/src/features/home/data/repositories/weather_repository_impl.dart';
import 'package:myapp/src/features/home/domain/usecases/get_weather_data.dart';
import 'package:fl_chart/fl_chart.dart';

class WeatherDetailsPage extends StatelessWidget {
  const WeatherDetailsPage({super.key});

  List<FlSpot> generateTemperatureData() {
    // Generate dummy data for temperature trend
    List<FlSpot> data = [];
    for (int i = 0; i < 30; i++) {
      double temperature = 20 + (i % 10) * 2 + (i % 5); // Dummy temperature data
      data.add(FlSpot(i.toDouble(), temperature));
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final WeatherRemoteDataSource remoteDataSource = WeatherRemoteDataSource();
    final WeatherRepositoryImpl repository =
        WeatherRepositoryImpl(remoteDataSource: remoteDataSource);
    final GetWeatherData getWeatherData =
        GetWeatherData(repository: repository);
    final String cityName = remoteDataSource.cityName;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: [
          // Current Weather Overview
          Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Weather',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<Map<String, dynamic>>(
                    future: getWeatherData.execute(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        final temperatureKelvin = data['main']['temp'];
                        final temperatureCelsius = temperatureKelvin - 273.15;
                        final description = data['weather'][0]['description'];
                        final humidity = data['main']['humidity'];
                        final windSpeed = data['wind']['speed'];

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
                            Text(cityName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                            Row(
                              children: [
                                Icon(weatherIcon, size: 40),
                                const SizedBox(width: 10),
                                Text('${temperatureCelsius.toStringAsFixed(1)} °C', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Text(description, style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.water_drop),
                                    const SizedBox(width: 5),
                                    Text('Humidity: $humidity%'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.air),
                                    const SizedBox(width: 5),
                                    Text('Wind: $windSpeed m/s'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // Extended Forecast (Daily & Weekly)
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Icon(Icons.wb_sunny),
                        const Text('Tomorrow'),
                        const Text('32°C'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Weather Trends & Past Data (Graphs & Charts)
          Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AspectRatio(
                aspectRatio: 1.5,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: const Color(0xff37434d), width: 1),
                    ),
                    minX: 0,
                    maxX: 29,
                    minY: 0,
                    maxY: 40,
                    lineBarsData: [
                      LineChartBarData(
                        spots: generateTemperatureData(),
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Insights Section
          Card(
            margin: const EdgeInsets.all(16.0),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('AI-powered insights based on weather analysis will be displayed here'),
            ),
          ),

          // Refresh Button & Data Source Attribution
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Refresh'),
                ),
                const Text('Powered by OpenWeather API'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
