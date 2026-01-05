import 'package:cashio/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CustomDatePickerFormField extends FormField<DateTime> {
  CustomDatePickerFormField({
    super.key,
    super.validator,
    DateTime? initialDate,
    required ValueChanged<DateTime> onDateSelected,
    DateTime? firstDate,
    DateTime? lastDate,
    String? hintText,
    bool autovalidate = false,
  }) : super(
         initialValue: initialDate,
         autovalidateMode: autovalidate
             ? AutovalidateMode.always
             : AutovalidateMode.disabled,
         builder: (field) {
           // No cast needed
           final state = field;

           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               OutlinedButton(
                 onPressed: () async {
                   final now = DateTime.now();
                   final pickedDate = await showDatePicker(
                     context: state.context,
                     initialDate: state.value ?? initialDate ?? now,
                     firstDate: firstDate ?? DateTime(now.year - 5),
                     lastDate: lastDate ?? DateTime(now.year + 5),
                   );
                   if (pickedDate != null) {
                     state.didChange(pickedDate);
                     onDateSelected(pickedDate);
                   }
                 },
                 style: OutlinedButton.styleFrom(
                   padding: const EdgeInsets.symmetric(
                     horizontal: 16,
                     vertical: 10,
                   ),
                   side: BorderSide(
                     color: state.hasError
                         ? Theme.of(state.context).colorScheme.error
                         : const Color.fromARGB(255, 123, 122, 122),
                   ),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(30),
                   ),
                 ),
                 child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Text(
                       state.value != null
                           ? DateFormat('dd / MMM / yyyy').format(state.value!)
                           : hintText ?? 'Select a date',
                       style: GoogleFonts.outfit(
                         fontSize: 16,
                         color: state.value != null
                             ? AppColors.textSecondary
                             : const Color.fromARGB(255, 62, 63, 64),
                       ),
                     ),
                     const SizedBox(width: 8),
                     const Icon(Icons.calendar_month, color: AppColors.primary),
                   ],
                 ),
               ),
               if (state.hasError)
                 Padding(
                   padding: const EdgeInsets.only(top: 5, left: 16),
                   child: Text(
                     state.errorText!,
                     style: TextStyle(
                       color: Theme.of(state.context).colorScheme.error,
                       fontSize: 12,
                     ),
                   ),
                 ),
             ],
           );
         },
       );
}
