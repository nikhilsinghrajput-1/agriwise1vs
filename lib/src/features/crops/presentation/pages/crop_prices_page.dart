import 'package:flutter/material.dart';
import '../../domain/entities/crop.dart';
import 'package:fl_chart/fl_chart.dart';

class CropPricesPage extends StatefulWidget {
  final Crop crop;

  const CropPricesPage({
    super.key,
    required this.crop,
  });

  @override
  State<CropPricesPage> createState() => _CropPricesPageState();
}

class _CropPricesPageState extends State<CropPricesPage> {
  // Mock data for prices (replace with actual API data)
  final List<Map<String, dynamic>> _priceHistory = [
    {'date': '2024-01-01', 'price': 2500},
    {'date': '2024-01-15', 'price': 2600},
    {'date': '2024-02-01', 'price': 2800},
    {'date': '2024-02-15', 'price': 2700},
    {'date': '2024-03-01', 'price': 2900},
    {'date': '2024-03-15', 'price': 3000},
  ];

  final List<Map<String, dynamic>> _marketPrices = [
    {'market': 'Delhi', 'price': 3000, 'trend': 'up'},
    {'market': 'Mumbai', 'price': 2900, 'trend': 'down'},
    {'market': 'Kolkata', 'price': 2800, 'trend': 'stable'},
    {'market': 'Chennai', 'price': 3100, 'trend': 'up'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.crop.name} Prices'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentPriceCard(),
            const SizedBox(height: 16),
            _buildPriceHistoryChart(),
            const SizedBox(height: 16),
            _buildMarketPricesCard(),
            const SizedBox(height: 16),
            _buildPriceAlertsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPriceCard() {
    final currentPrice = _priceHistory.last['price'];
    final previousPrice = _priceHistory[_priceHistory.length - 2]['price'];
    final priceChange = currentPrice - previousPrice;
    final priceChangePercentage = (priceChange / previousPrice) * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Price',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${currentPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: priceChange >= 0 ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        priceChange >= 0
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: Colors.white,
                        size: 16,
                      ),
                      Text(
                        '${priceChangePercentage.abs().toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${_priceHistory.last['date']}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceHistoryChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price History',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _priceHistory.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value['price'].toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketPricesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Market Prices',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _marketPrices.length,
              itemBuilder: (context, index) {
                final market = _marketPrices[index];
                return ListTile(
                  title: Text(market['market']),
                  subtitle: Text('₹${market['price'].toStringAsFixed(2)}'),
                  trailing: Icon(
                    market['trend'] == 'up'
                        ? Icons.arrow_upward
                        : market['trend'] == 'down'
                            ? Icons.arrow_downward
                            : Icons.remove,
                    color: market['trend'] == 'up'
                        ? Colors.green
                        : market['trend'] == 'down'
                            ? Colors.red
                            : Colors.grey,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceAlertsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price Alerts',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement price alert setting
              },
              icon: const Icon(Icons.add_alert),
              label: const Text('Set Price Alert'),
            ),
            const SizedBox(height: 16),
            const Text('No active alerts'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // TODO: Implement alert history
              },
              child: const Text('View Alert History'),
            ),
          ],
        ),
      ),
    );
  }
}
