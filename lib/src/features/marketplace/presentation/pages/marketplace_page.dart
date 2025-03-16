import 'package:flutter/material.dart';

import 'product_details_page.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // TODO: Implement cart functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<String>(
                  value: 'Category',
                  items: const [
                    DropdownMenuItem(
                      value: 'Category',
                      child: Text('Category'),
                    ),
                    DropdownMenuItem(
                      value: 'Seeds',
                      child: Text('Seeds'),
                    ),
                    DropdownMenuItem(
                      value: 'Fertilizers',
                      child: Text('Fertilizers'),
                    ),
                    DropdownMenuItem(
                      value: 'Equipment',
                      child: Text('Equipment'),
                    ),
                  ],
                  onChanged: (value) {
                    // TODO: Implement category filter
                  },
                ),
                DropdownButton<String>(
                  value: 'Price',
                  items: const [
                    DropdownMenuItem(
                      value: 'Price',
                      child: Text('Price'),
                    ),
                    DropdownMenuItem(
                      value: 'Low to High',
                      child: Text('Low to High'),
                    ),
                    DropdownMenuItem(
                      value: 'High to Low',
                      child: Text('High to Low'),
                    ),
                  ],
                  onChanged: (value) {
                    // TODO: Implement price filter
                  },
                ),
                DropdownButton<String>(
                  value: 'Supplier',
                  items: const [
                    DropdownMenuItem(
                      value: 'Supplier',
                      child: Text('Supplier'),
                    ),
                    DropdownMenuItem(
                      value: 'Local',
                      child: Text('Local'),
                    ),
                    DropdownMenuItem(
                      value: 'Verified',
                      child: Text('Verified'),
                    ),
                    DropdownMenuItem(
                      value: 'Bulk Orders',
                      child: Text('Bulk Orders'),
                    ),
                  ],
                  onChanged: (value) {
                    // TODO: Implement supplier filter
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Product Listings
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    child: ListTile(
                      leading: Image.network(product.imageUrl),
                      title: Text(product.name),
                      subtitle: Text('\$${product.price} - ${product.supplier}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsPage(product: product),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Verified Suppliers Section
            const Text(
              'Verified Suppliers',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                final supplier = suppliers[index];
                return Card(
                  child: ListTile(
                    title: Text(supplier.name),
                    subtitle: Text(supplier.contact),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.phone),
                          onPressed: () {
                            // TODO: Implement call supplier functionality
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.chat),
                          onPressed: () {
                            // TODO: Implement chat with supplier functionality
                          },
                        ),
                      ],
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
}

class Product {
  final String name;
  final double price;
  final String supplier;
  final String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.supplier,
    required this.imageUrl,
  });
}

final List<Product> products = [
  Product(
    name: 'Hybrid Seeds',
    price: 25.00,
    supplier: 'Local Supplier',
    imageUrl: 'https://via.placeholder.com/150',
  ),
  Product(
    name: 'Nitrogen Fertilizer',
    price: 40.00,
    supplier: 'Verified Supplier',
    imageUrl: 'https://via.placeholder.com/150',
  ),
  Product(
    name: 'Pesticide X',
    price: 30.00,
    supplier: 'Bulk Orders',
    imageUrl: 'https://via.placeholder.com/150',
  ),
  Product(
    name: 'Tractor Model Y',
    price: 1500.00,
    supplier: 'Local Supplier',
    imageUrl: 'https://via.placeholder.com/150',
  ),
];

class Supplier {
  final String name;
  final String contact;

  Supplier({
    required this.name,
    required this.contact,
  });
}

final List<Supplier> suppliers = [
  Supplier(
    name: 'Supplier A',
    contact: '123-456-7890',
  ),
  Supplier(
    name: 'Supplier B',
    contact: '456-789-0123',
  ),
];
