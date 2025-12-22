import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/features/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Log out?',
        style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      content: Text(
        'Are you sure you want to log out?',
        style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey.shade700),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            ref.read(signOutProvider).call();
            Navigator.pop(context);
          },

          child: Text(
            'Log out',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textWhite,
            ),
          ),
        ),
      ],
    );
  }
}
