import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SoilIrrigationPage extends StatelessWidget {
  const SoilIrrigationPage({super.key});

  List<FlSpot> generateSoilMoistureData() {
    // Generate dummy data for soil moisture trend
    List<FlSpot> data = [];
    for (int i = 0; i < 30; i++) {
      double moisture = 30 + (i % 10) * 1.5 + (i % 5); // Dummy moisture data
      data.add(FlSpot(i.toDouble(), moisture));
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soil & Irrigation Insights', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Current Soil Moisture & Health Overview
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Soil Moisture & Health',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text('Soil Moisture: 45%', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  const Text('Soil Health: Good', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: const [
                          Text('pH Level'),
                          Text('6.5'),
                        ],
                      ),
                      Column(
                        children: const [
                          Text('Nitrogen'),
                          Text('High'),
                        ],
                      ),
                      Column(
                        children: const [
                          Text('Phosphorus'),
                          Text('Medium'),
                        ],
                      ),
                      Column(
                        children: const [
                          Text('Potassium'),
                          Text('High'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Soil & Moisture Trends (Graphical Representation)
          Card(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Soil Moisture Trends (Last 30 Days)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  AspectRatio(
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
                        maxY: 50,
                        lineBarsData: [
                          LineChartBarData(
                            spots: generateSoilMoistureData(),
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
                ],
              ),
            ),
          ),

          // AI-Generated Irrigation Schedule
          Card(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI-Generated Irrigation Schedule',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Recommended Irrigation Plan:'),
                  Text('Irrigate 3 times a week, 20 liters per plant'),
                ],
              ),
            ),
          ),

          // Manual Watering Log (Farmer Input Section)
          Card(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Manual Watering Log will be implemented here'),
            ),
          ),

          // Additional Recommendations
          Card(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Additional Recommendations will be implemented here'),
            ),
          ),
        ],
      ),
    );
  }
}
