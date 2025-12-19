import 'package:cashio/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddExpensesSavingsBottomsheet extends StatefulWidget {
  const AddExpensesSavingsBottomsheet({super.key});

  @override
  State<AddExpensesSavingsBottomsheet> createState() =>
      _AddExpensesSavingsBottomsheetState();
}

class _AddExpensesSavingsBottomsheetState
    extends State<AddExpensesSavingsBottomsheet> {
  final TextEditingController _amountController = TextEditingController();

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
    return Container(
      height: 500,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
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
            value: selectedCategory,
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

          const Spacer(),

          SafeArea(
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
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
