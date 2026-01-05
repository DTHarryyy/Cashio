import 'package:cashio/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String hint;
  final VoidCallback? onPressed;
  const CustomButton({super.key, required this.hint, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
      onPressed: onPressed,
      child: Text(hint, style: GoogleFonts.outfit(color: AppColors.textWhite)),
    );
  }
}
