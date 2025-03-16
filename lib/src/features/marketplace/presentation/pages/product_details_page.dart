import 'package:flutter/material.dart';

import '../pages/marketplace_page.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.imageUrl),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${product.price}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Supplier Information:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Supplier: ${product.supplier}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement contact supplier functionality
              },
              child: const Text('Contact Supplier'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement add to cart functionality
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
