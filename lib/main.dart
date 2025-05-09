import 'package:flutter/material.dart';
import 'package:catatan_harian/screens/splash_screen.dart';
import 'package:catatan_harian/utils/constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:catatan_harian/services/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi database hanya jika bukan di web
  if (!kIsWeb) {
    await DatabaseHelper.instance.database;
  }
  
  runApp(const CatatanHarianApp());
}

class CatatanHarianApp extends StatelessWidget {
  const CatatanHarianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Harian',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.tertiary,
          background: AppColors.background,
          surface: AppColors.surface,
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(color: AppColors.primary),
          displayMedium: TextStyle(color: AppColors.primary),
          bodyLarge: TextStyle(color: AppColors.primary),
          bodyMedium: TextStyle(color: AppColors.primary),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.tertiary,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.tertiary,
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.tertiary, width: 2.0),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: kIsWeb ? const WebAppNotice() : const SplashScreen(),
    );
  }
}

class WebAppNotice extends StatelessWidget {
  const WebAppNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 80,
                color: AppColors.tertiary,
              ),
              const SizedBox(height: 24),
              Text(
                'Aplikasi Catatan Harian',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Maaf, aplikasi ini menggunakan SQLite yang tidak didukung di platform web. Untuk pengalaman terbaik, silakan jalankan di perangkat Android atau iOS.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              Text(
                AppStrings.copyright,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}