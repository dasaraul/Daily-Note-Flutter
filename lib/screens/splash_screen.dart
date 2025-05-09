import 'package:flutter/material.dart';
import 'package:catatan_harian/screens/home_screen.dart';
import 'package:catatan_harian/utils/constants.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo atau gambar
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Lottie.asset(
                  'assets/loading_animation.json',
                  repeat: true,
                  animate: true,
                  frameRate: FrameRate(60),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Judul aplikasi
            Text(
              AppStrings.appName,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Catat momen berharga setiap hari",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.tertiary,
              ),
            ),
            const SizedBox(height: 60),
            // Copyright footer
            Text(
              AppStrings.copyright,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.primary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}