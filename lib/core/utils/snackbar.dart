import 'package:cashio/core/constant/app_colors.dart';
import 'package:flutter/material.dart';

class AppSnackBar {
  static void success(BuildContext context, String message) {
    _show(
      context,
      message,
      icon: Icons.check_circle,
      backgroundColor: AppColors.success,
    );
  }

  static void error(BuildContext context, String message) {
    _show(
      context,
      message,
      icon: Icons.error,
      backgroundColor: AppColors.error,
    );
  }

  static void info(BuildContext context, String message) {
    _show(
      context,
      message,
      icon: Icons.info,
      backgroundColor: AppColors.primary,
    );
  }

  static void warning(BuildContext context, String message) {
    _show(
      context,
      message,
      icon: Icons.warning,
      backgroundColor: Colors.orange,
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    required IconData icon,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.fixed,
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
