import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firebase_service.dart';
import '../utils/app_colors.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseService.currentUser;

    if (user == null) {
      return const Center(child: Text('Please log in to view your orders.'));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Orders'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('customerId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong. Please try again.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_laundry_service_outlined,
                    size: 75,
                    color: AppColors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No Orders Yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your laundry orders will appear here.',
                    style: TextStyle(color: AppColors.grey),
                  ),
                ],
              ),
            );
          }

          final sortedOrders = [...orders];

          sortedOrders.sort((a, b) {
            final aData = a.data() as Map<String, dynamic>;
            final bData = b.data() as Map<String, dynamic>;

            final aDate = aData['createdAt'] as Timestamp?;
            final bDate = bData['createdAt'] as Timestamp?;

            return (bDate?.millisecondsSinceEpoch ?? 0).compareTo(
              aDate?.millisecondsSinceEpoch ?? 0,
            );
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedOrders.length,
            itemBuilder: (context, index) {
              final order = sortedOrders[index];
              final data = order.data() as Map<String, dynamic>;

              final service = data['serviceName'] ?? 'Laundry Service';
              final quantity = data['quantity'] ?? 0;
              final total = data['estimatedTotal'] ?? 0;
              final status = data['status'] ?? 'Pending';
              final address = data['pickupAddress'] ?? 'No address';
              final notes = data['notes'] ?? '';

              final pickupTimestamp = data['pickupDate'] as Timestamp?;
              final pickupDate = pickupTimestamp?.toDate();

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.local_laundry_service,
                            color: AppColors.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              service.toString(),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          _statusBadge(status.toString()),
                        ],
                      ),
                      const Divider(height: 24),
                      _detailRow('Quantity', '$quantity load(s)'),
                      _detailRow('Estimated Total', '₱$total'),
                      _detailRow(
                        'Pickup Date',
                        pickupDate == null
                            ? 'Not specified'
                            : '${pickupDate.day}/${pickupDate.month}/${pickupDate.year}',
                      ),
                      _detailRow('Pickup Address', address.toString()),
                      if (notes.toString().isNotEmpty)
                        _detailRow('Notes', notes.toString()),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(label, style: const TextStyle(color: AppColors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;

    switch (status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        break;
      case 'processing':
        color = Colors.orange;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = AppColors.secondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
