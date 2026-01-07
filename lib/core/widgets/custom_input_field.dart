import 'package:cashio/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isNumber;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? initialValue;
  const CustomInputField({
    super.key,
    required this.hint,
    required this.icon,
    required this.isNumber,
    required this.controller,
    this.validator,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: isNumber
          ? TextInputType.numberWithOptions(decimal: true)
          : null,

      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15),
        errorStyle: GoogleFonts.outfit(fontSize: 13, color: AppColors.error),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        label: Text(hint, style: GoogleFonts.outfit(fontSize: 16)),
        floatingLabelStyle: GoogleFonts.outfit(
          fontSize: 13,
          color: AppColors.textPrimary,
        ),
        suffixIcon: Icon(icon, color: AppColors.primary),
      ),
    );
  }
}
