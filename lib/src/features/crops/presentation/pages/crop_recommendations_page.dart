import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

class CropRecommendationsPage extends StatefulWidget {
  const CropRecommendationsPage({super.key});

  @override
  State<CropRecommendationsPage> createState() => _CropRecommendationsPageState();
}

class _CropRecommendationsPageState extends State<CropRecommendationsPage> {
  Weather? _currentWeather;
  bool _isLoading = true;
  String? _error;
  String _selectedSoilType = 'Loamy';
  double _soilPh = 6.5;
  double _soilMoisture = 60;

  final List<String> _soilTypes = [
    'Loamy',
    'Clayey',
    'Sandy',
    'Black',
    'Red',
  ];

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      
      WeatherFactory wf = WeatherFactory('YOUR_API_KEY'); // Replace with actual API key
      Weather current = await wf.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentWeather = current;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getRecommendations() {
    if (_currentWeather == null) return [];

    final temperature = _currentWeather!.temperature?.celsius ?? 0;
    final humidity = _currentWeather!.humidity ?? 0;

    List<Map<String, dynamic>> recommendations = [];

    // Rice recommendations
    if (temperature >= 20 && temperature <= 35 && humidity >= 60) {
      recommendations.add({
        'name': 'Rice',
        'varieties': ['Basmati', 'Sona Masuri', 'IR64'],
        'confidence': 85,
        'reason': 'Favorable temperature and humidity for rice cultivation',
      });
    }

    // Wheat recommendations
    if (temperature >= 15 && temperature <= 25 && humidity >= 40) {
      recommendations.add({
        'name': 'Wheat',
        'varieties': ['HD 3086', 'PBW 343', 'DBW 17'],
        'confidence': 80,
        'reason': 'Suitable temperature range for wheat growth',
      });
    }

    // Cotton recommendations
    if (temperature >= 25 && temperature <= 35 && humidity >= 50) {
      recommendations.add({
        'name': 'Cotton',
        'varieties': ['Bollgard II', 'RCH 2', 'MECH 162'],
        'confidence': 75,
        'reason': 'Optimal conditions for cotton cultivation',
      });
    }

    // Maize recommendations
    if (temperature >= 20 && temperature <= 30 && humidity >= 50) {
      recommendations.add({
        'name': 'Maize',
        'varieties': ['DHM 117', 'Pioneer 30V92', 'DKC 9108'],
        'confidence': 80,
        'reason': 'Favorable conditions for maize growth',
      });
    }

    // Sort recommendations by confidence
    recommendations.sort((a, b) => (b['confidence'] as int).compareTo(a['confidence'] as int));

    return recommendations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Recommendations'),
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
                      _buildWeatherCard(),
                      const SizedBox(height: 16),
                      _buildSoilCard(),
                      const SizedBox(height: 16),
                      _buildRecommendationsCard(),
                    ],
                  ),
                ),
    );
  }

 Widget _buildWeatherCard() {
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherInfo(
                  'Humidity',
                  '${_currentWeather!.humidity}%',
                  Icons.water_drop,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoilCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Soil Conditions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSoilType,
              decoration: const InputDecoration(
                labelText: 'Soil Type',
                border: OutlineInputBorder(),
              ),
              items: _soilTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedSoilType = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            Text('Soil pH: ${_soilPh.toStringAsFixed(1)}'),
            Slider(
              value: _soilPh,
              min: 0,
              max: 14,
              divisions: 28,
              label: _soilPh.toStringAsFixed(1),
              onChanged: (double value) {
                setState(() {
                  _soilPh = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Text('Soil Moisture: ${_soilMoisture.toStringAsFixed(1)}%'),
            Slider(
              value: _soilMoisture,
              min: 0,
              max: 100,
              divisions: 20,
              label: '${_soilMoisture.toStringAsFixed(1)}%',
              onChanged: (double value) {
                setState(() {
                  _soilMoisture = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    final recommendations = _getRecommendations();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommended Crops',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (recommendations.isEmpty)
              const Text('No suitable crops found for current conditions.')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final recommendation = recommendations[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        recommendation['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Varieties: ${recommendation['varieties'].join(", ")}'),
                          Text('Confidence: ${recommendation['confidence']}%'),
                          Text(recommendation['reason']),
                        ],
                      ),
                      trailing: CircularProgressIndicator(
                        value: recommendation['confidence'] / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getConfidenceColor(recommendation['confidence']),
                        ),
                      ),
                    ),
                  );
                },
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

  Color _getConfidenceColor(int confidence) {
    if (confidence >= 80) return Colors.green;
    if (confidence >= 60) return Colors.orange;
    return Colors.red;
  }
}
