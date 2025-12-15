import 'package:cashio/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final bool isPassword;
  final IconData? icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.isPassword,
    this.icon,
    required this.controller,
    required this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (_) {
        setState(() {});
      },
      validator: widget.validator,
      obscureText: widget.isPassword,
      controller: widget.controller,

      decoration: InputDecoration(
        labelText: widget.hint,

        labelStyle: GoogleFonts.outfit(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),

        errorStyle: GoogleFonts.outfit(fontSize: 12, color: AppColors.error),

        filled: true,
        fillColor: AppColors.border,

        prefixIcon: widget.icon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 15, right: 10),
                child: Icon(widget.icon, size: 20),
              )
            : null,

        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 14),
                onPressed: () {
                  widget.controller.clear();
                  setState(() {});
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 18,
        ),
        floatingLabelStyle: GoogleFonts.outfit(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide.none,
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Colors.red),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
