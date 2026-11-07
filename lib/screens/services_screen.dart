import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import 'order_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  static const List<Map<String, dynamic>> services = [
    {
      'name': 'Wash & Fold',
      'description':
          'Complete washing, drying, and folding of everyday clothes.',
      'price': 80,
      'unit': 'per load',
      'icon': Icons.local_laundry_service,
    },
    {
      'name': 'Dry Cleaning',
      'description': 'Special cleaning care for delicate and formal garments.',
      'price': 120,
      'unit': 'starting price',
      'icon': Icons.checkroom,
    },
    {
      'name': 'Ironing',
      'description': 'Keep your clothes neat, fresh, and wrinkle-free.',
      'price': 50,
      'unit': 'starting price',
      'icon': Icons.iron,
    },
    {
      'name': 'Bedding & Linens',
      'description': 'Cleaning for blankets, bedsheets, and pillowcases.',
      'price': 150,
      'unit': 'starting price',
      'icon': Icons.bed,
    },
  ];

  void openOrderScreen(BuildContext context, Map<String, dynamic> service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderScreen(
          serviceName: service['name'] as String,
          unitPrice: service['price'] as int,
          unit: service['unit'] as String,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Our Laundry Services',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose the service that fits your laundry needs.',
            style: TextStyle(color: AppColors.grey, fontSize: 14),
          ),
          const SizedBox(height: 22),

          ...services.map((service) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          service['icon'] as IconData,
                          color: AppColors.primary,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          service['name'] as String,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    service['description'] as String,
                    style: const TextStyle(color: AppColors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₱${service['price']}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            service['unit'] as String,
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          openOrderScreen(context, service);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Select Service'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
