import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:catatan_harian/utils/constants.dart';

class LoadingWidget extends StatelessWidget {
  final String message;
  
  const LoadingWidget({
    super.key, 
    this.message = AppStrings.loading
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          color: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Lottie.asset(
                    'assets/loading_animation.json',
                    repeat: true,
                    animate: true,
                    frameRate: FrameRate(60),
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}