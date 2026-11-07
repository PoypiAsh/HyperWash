import 'package:flutter/material.dart';

import '../services/firebase_service.dart';
import '../utils/app_colors.dart';
import 'login_screen.dart';
import 'services_screen.dart';
import 'orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  String get customerName {
    final name = FirebaseService.currentUser?.displayName;
    return name != null && name.isNotEmpty ? name : 'Customer';
  }

  Future<void> logout() async {
    await FirebaseService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  Widget buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, $customerName!',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Ready to make your laundry fresh and clean?',
            style: TextStyle(color: AppColors.grey),
          ),
          const SizedBox(height: 25),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.local_laundry_service,
                  color: Colors.white,
                  size: 40,
                ),
                SizedBox(height: 15),
                Text(
                  'Laundry made easier!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Let HyperWash take care of your laundry needs.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Our Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 15),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: const [
              _ServiceTile(
                title: 'Wash & Fold',
                icon: Icons.local_laundry_service,
              ),
              _ServiceTile(title: 'Dry Cleaning', icon: Icons.checkroom),
              _ServiceTile(title: 'Ironing', icon: Icons.iron),
              _ServiceTile(title: 'Bedding & Linens', icon: Icons.bed),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(15),
              ),
              onPressed: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
              child: const Text('Explore All Services'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfilePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 15),
          Text(
            customerName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            FirebaseService.currentUser?.email ?? '',
            style: const TextStyle(color: AppColors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHomePage(),
      const ServicesScreen(),
      const OrdersScreen(),
      buildProfilePage(),
    ];

    const titles = ['HyperWash', 'Laundry Services', 'My Orders', 'My Profile'];

    return Scaffold(
      appBar: selectedIndex == 2
          ? null
          : AppBar(
              title: Text(
                titles[selectedIndex],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  onPressed: logout,
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                ),
              ],
            ),
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_laundry_service_outlined),
            selectedIcon: Icon(Icons.local_laundry_service),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ServiceTile({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.secondary, size: 32),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
