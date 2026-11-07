import 'package:flutter/material.dart';

import '../services/firebase_service.dart';
import '../utils/app_colors.dart';

class OrderScreen extends StatefulWidget {
  final String serviceName;
  final int unitPrice;
  final String unit;

  const OrderScreen({
    super.key,
    required this.serviceName,
    required this.unitPrice,
    required this.unit,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  int quantity = 1;
  bool isSubmitting = false;

  DateTime pickupDate = DateTime.now().add(const Duration(days: 1));

  String formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  Future<void> choosePickupDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: pickupDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (selectedDate != null) {
      setState(() {
        pickupDate = selectedDate;
      });
    }
  }

  Future<void> submitOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await FirebaseService.placeOrder(
        serviceName: widget.serviceName,
        quantity: quantity,
        unitPrice: widget.unitPrice,
        pickupAddress: _addressController.text.trim(),
        notes: _notesController.text.trim(),
        pickupDate: pickupDate,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your order has been submitted!'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to submit order: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estimatedTotal = quantity * widget.unitPrice;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selected Service',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.serviceName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₱${widget.unitPrice} ${widget.unit}',
                      style: const TextStyle(color: AppColors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Quantity',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  IconButton(
                    onPressed: quantity > 1
                        ? () => setState(() => quantity--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text(
                    '$quantity',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: quantity < 20
                        ? () => setState(() => quantity++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                  const Text(
                    '(Maximum 20)',
                    style: TextStyle(color: AppColors.grey, fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Pickup Address',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Enter your complete pickup address',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your pickup address.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Preferred Pickup Date',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: choosePickupDate,
                  icon: const Icon(Icons.calendar_month),
                  label: Text(formatDate(pickupDate)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Additional Notes (Optional)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Any special instructions?',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estimated Total',
                      style: TextStyle(color: AppColors.grey),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₱$estimatedTotal',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Final price may change after laundry assessment.',
                      style: TextStyle(fontSize: 11, color: AppColors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'PLACE ORDER',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
