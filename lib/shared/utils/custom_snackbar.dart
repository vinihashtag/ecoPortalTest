import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  CustomSnackbar._();

  static void showMessageSuccess({String? title, required String message, Duration? duration, Function()? onTap}) {
    _showSnackBar(
      title: title ?? 'Success',
      message: message,
      color: Colors.green,
      icon: Icons.check_circle_outline,
      duration: duration,
      onTap: onTap,
    );
  }

  static void showMessageError({String? title, required String message, Duration? duration, Function()? onTap}) {
    _showSnackBar(
      title: title ?? 'Error',
      message: message,
      color: Colors.red,
      icon: Icons.error_outline_outlined,
      duration: duration,
      onTap: onTap,
    );
  }

  static void _showSnackBar(
      {String? title,
      required String message,
      required Color color,
      required IconData icon,
      Duration? duration,
      Function()? onTap}) {
    Get.snackbar(
      '', '',
      maxWidth: Get.width,
      backgroundColor: color,
      colorText: Colors.white,
      duration: duration ?? const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 500),

      // * Icon
      shouldIconPulse: true,
      icon: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Icon(icon, color: Colors.white, size: 45),
      ),

      // * Title Widget
      titleText: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Text(
          title ?? 'Error',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            height: 1.0,
          ),
        ),
      ),

      // * Message Widget
      messageText: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),

      // * OnTap SnackBar
      onTap: (snack) {
        Get.closeCurrentSnackbar();
        0.1.delay(() => onTap?.call());
      },
    );
  }
}
