import 'package:cashio/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CFilterClip extends StatelessWidget {
  final List filter;
  final int selectedvalue;
  final ValueChanged onChange;
  const CFilterClip({
    super.key,
    required this.filter,
    required this.selectedvalue,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: List<Widget>.generate(filter.length, (index) {
        return ChoiceChip(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(35),
          ),
          label: Text(
            filter[index],
            style: GoogleFonts.outfit(
              color: selectedvalue == index ? AppColors.textWhite : null,
            ),
          ),
          checkmarkColor: selectedvalue == index ? AppColors.textWhite : null,
          selected: selectedvalue == index,
          selectedColor: AppColors.primary,

          onSelected: (bool selected) {
            if (selected) {
              onChange(index);
            }
          },
        );
      }).toList(),
    );
  }
}
