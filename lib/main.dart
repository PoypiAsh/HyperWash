import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/login_screen.dart';
import 'utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyD-TJC6kTLE8A7xMEnOykhfuQfDqZx-w7A',
        authDomain: 'hyperwash-f01cb.firebaseapp.com',
        projectId: 'hyperwash-f01cb',
        storageBucket: 'hyperwash-f01cb.firebasestorage.app',
        messagingSenderId: '874073540608',
        appId: '1:874073540608:web:2513141d2f5d136d5d70e5',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const HyperWashApp());
}

class HyperWashApp extends StatelessWidget {
  const HyperWashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HyperWash',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
