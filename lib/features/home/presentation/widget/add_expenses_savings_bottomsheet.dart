import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/utils/snackbar.dart';
import 'package:cashio/features/auth/presentation/sign_in_page.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:cashio/features/home/provider/expenses_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddExpensesSavingsBottomsheet extends ConsumerStatefulWidget {
  const AddExpensesSavingsBottomsheet({super.key});

  @override
  ConsumerState<AddExpensesSavingsBottomsheet> createState() =>
      _AddExpensesSavingsBottomsheetState();
}

class _AddExpensesSavingsBottomsheetState
    extends ConsumerState<AddExpensesSavingsBottomsheet> {
  final List<String> dropDownList = [
    'Housing',
    'Utilities',
    'Food',
    'Transportation',
    'Shopping',
    'Health',
    'Education',
    'Entertainment',
    'Travel',
    'Subscriptions',
    'Personal',
    'Insurance',
    'Gifts & Donations',
    'Taxes',
    'Miscellaneous',
  ];

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _expensesname = TextEditingController();
  DateTime? date;
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = dropDownList.first;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(profileProvider).value;
    if (user == null) return SignInPage();
    return Container(
      height: 500,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 5,
            width: 100,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(25),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              Expanded(
                child: Text(
                  'Add Transaction',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 50),
            ],
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _expensesname,
            decoration: InputDecoration(
              hintText: 'Expense name',
              filled: true,
              fillColor: AppColors.border,
              border: InputBorder.none,
              hintStyle: GoogleFonts.outfit(fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
            ],

            decoration: InputDecoration(
              hintText: 'Amount',
              prefixText: '₱',
              filled: true,
              fillColor: AppColors.border,
              border: InputBorder.none,
              hintStyle: GoogleFonts.outfit(fontSize: 16),
            ),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            initialValue: selectedCategory,
            items: dropDownList
                .map(
                  (cate) => DropdownMenuItem(
                    value: cate,
                    child: Text(cate, style: GoogleFonts.outfit(fontSize: 16)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() => selectedCategory = value!);
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.border,
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 12),

          CustomDatePicker(
            ondateSelected: (value) {
              date = value;
            },
          ),
          const Spacer(),

          SafeArea(
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                //TODO: do validation for input
                onPressed: () async {
                  try {
                    double? amount = double.tryParse(_amountController.text);
                    if (amount == null) {
                      AppSnackBar.info(context, 'Please enter valid amount');
                      return;
                    }
                    await ref
                        .read(addExpensesProvider)
                        .call(
                          expensesName: _expensesname.text.trim(),
                          userId: user.userId,
                          amount: amount,
                          category: selectedCategory,
                          expensesDate: date,
                        );
                    if (!context.mounted) return;
                    AppSnackBar.success(context, 'Sucessfully added expenses');
                    Navigator.pop(context);
                  } catch (e) {
                    AppSnackBar.error(context, 'Error: $e/');
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(AppColors.primary),
                ),
                child: Text(
                  'Add',
                  style: GoogleFonts.outfit(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
