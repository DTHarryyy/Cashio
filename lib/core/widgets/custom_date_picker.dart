import 'package:cashio/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final ValueChanged<DateTime> ondateSelected;
  const CustomDatePicker({super.key, required this.ondateSelected});
  @override
  State<CustomDatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<CustomDatePicker> {
  DateTime? dateSelected;
  Future<void> _selectDate() async {
    final now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dateSelected ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (pickedDate != null) {
      setState(() {
        dateSelected = pickedDate;
      });
      widget.ondateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: _selectDate,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dateSelected == null
                ? 'DD / MMM / YYYY'
                : DateFormat('dd / MMM / yyyy').format(dateSelected!),
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.calendar_month, color: AppColors.primary),
        ],
      ),
    );
  }
}
