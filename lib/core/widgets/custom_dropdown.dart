import 'package:cashio/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdown<T> extends StatelessWidget {
  final ValueChanged valueChange;
  final List<T> items;
  final String? hint;
  final String Function(T item) labelBuilder;
  final String? Function(T?)? validator;
  const CustomDropdown({
    super.key,
    required this.valueChange,
    required this.hint,
    required this.items,
    required this.labelBuilder,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      validator: validator,
      decoration: InputDecoration(
        errorStyle: GoogleFonts.outfit(fontSize: 13, color: AppColors.error),
        suffixIcon: Icon(
          Icons.arrow_drop_down_rounded,
          size: 28,
          color: AppColors.primary,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),

      hint: hint == null ? null : Text(hint!, style: GoogleFonts.outfit()),
      items: items.map((e) {
        return DropdownMenuItem(value: e, child: Text(labelBuilder(e)));
      }).toList(),
      onChanged: valueChange,
    );
  }
}
