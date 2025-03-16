import 'package:flutter/material.dart';

class DataVisualization extends StatelessWidget {
  const DataVisualization({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Data Visualization',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        // Add charts here
        Container(
          height: 200,
          color: Colors.grey[200],
          child: const Center(
            child: Text('Placeholder for data visualization charts'),
          ),
        ),
      ],
    );
  }
}
