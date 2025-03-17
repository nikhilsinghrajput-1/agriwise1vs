import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/crop_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

class WeatherPage extends StatefulWidget {
  final Crop crop;

  const WeatherPage({
    Key? key,
    required this.crop,
  }) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Weather? _currentWeather;
  List<Weather> _forecast = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    try {
      // Get current location
      final position = await Geolocator.getCurrentPosition();
      
      // Fetch weather data
      WeatherFactory wf = WeatherFactory('YOUR_API_KEY'); // Replace with actual API key
      Weather current = await wf.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      
      List<Weather> forecast = await wf.fiveDayForecastByLocation(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentWeather = current;
        _forecast = forecast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.crop.name} Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWeatherData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadWeatherData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCurrentWeatherCard(),
                      const SizedBox(height: 16),
                      _buildForecastCard(),
                      const SizedBox(height: 16),
                      _buildWeatherImpactCard(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildCurrentWeatherCard() {
    if (_currentWeather == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Weather',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_currentWeather!.temperature?.celsius?.round()}°C',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      _currentWeather!.weatherMain ?? '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                Icon(
                  _getWeatherIcon(_currentWeather!.weatherMain ?? ''),
                  size: 48,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherInfo(
                  'Humidity',
                  '${_currentWeather!.humidity}%',
                  Icons.water_drop,
                ),
                _buildWeatherInfo(
                  'Wind',
                  '${_currentWeather!.windSpeed} m/s',
                  Icons.air,
                ),
                _buildWeatherInfo(
                  'Pressure',
                  '${_currentWeather!.pressure} hPa',
                  Icons.speed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '5-Day Forecast',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _forecast.length,
                itemBuilder: (context, index) {
                  final weather = _forecast[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        Text(
                          _formatDate(weather.date!),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Icon(
                          _getWeatherIcon(weather.weatherMain ?? ''),
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${weather.temperature?.celsius?.round()}°C',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherImpactCard() {
    if (_currentWeather == null) return const SizedBox.shrink();

    final temperature = _currentWeather!.temperature?.celsius ?? 0;
    final humidity = _currentWeather!.humidity ?? 0;
    final windSpeed = _currentWeather!.windSpeed ?? 0;

    String impact = '';
    Color impactColor = Colors.green;

    // Simple impact assessment based on weather conditions
    if (temperature < 10 || temperature > 35) {
      impact = 'High Risk: Extreme temperature conditions';
      impactColor = Colors.red;
    } else if (humidity < 30 || humidity > 80) {
      impact = 'Medium Risk: Unfavorable humidity levels';
      impactColor = Colors.orange;
    } else if (windSpeed > 20) {
      impact = 'High Risk: Strong winds may damage crops';
      impactColor = Colors.red;
    } else {
      impact = 'Low Risk: Favorable weather conditions';
      impactColor = Colors.green;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather Impact',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.warning,
                  color: impactColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    impact,
                    style: TextStyle(
                      color: impactColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildImpactRow(
              'Temperature',
              temperature,
              '°C',
              _getTemperatureRange(),
            ),
            _buildImpactRow(
              'Humidity',
              humidity,
              '%',
              _getHumidityRange(),
            ),
            _buildImpactRow(
              'Wind Speed',
              windSpeed,
              'm/s',
              _getWindRange(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildImpactRow(
    String label,
    double value,
    String unit,
    Map<String, double> range,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: (value - range['min']!) / (range['max']! - range['min']!),
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getImpactColor(value, range),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: Text(
              '${value.toStringAsFixed(1)}$unit',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Color _getImpactColor(double value, Map<String, double> range) {
    final normalizedValue = (value - range['min']!) / (range['max']! - range['min']!);
    if (normalizedValue < 0.3) return Colors.red;
    if (normalizedValue < 0.7) return Colors.orange;
    return Colors.green;
  }

  Map<String, double> _getTemperatureRange() {
    return {'min': 10, 'max': 35};
  }

  Map<String, double> _getHumidityRange() {
    return {'min': 30, 'max': 80};
  }

  Map<String, double> _getWindRange() {
    return {'min': 0, 'max': 20};
  }

  IconData _getWeatherIcon(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.beach_access;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      default:
        return Icons.wb_sunny;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }
} 