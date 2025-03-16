import 'package:flutter/material.dart';
import 'package:myapp/src/features/home/domain/entities/advisory.dart';

class AdvisoryCard extends StatelessWidget {
  final Advisory advisory;

  const AdvisoryCard({super.key, required this.advisory});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              advisory.description,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
