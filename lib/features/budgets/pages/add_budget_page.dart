import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/utils/list_categories.dart';
import 'package:cashio/core/widgets/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddBudgetPage extends StatelessWidget {
  const AddBudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add new budget',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            CustomInputField(
              hint: 'Title',
              icon: Icons.title_rounded,
              isNumber: false,
            ),
            CustomDropDown(),
            CustomInputField(
              hint: 'Amount',
              icon: Icons.attach_money_rounded,
              isNumber: true,
            ),
            CustomInputField(
              hint: 'Notes(optional)',
              icon: Icons.notes_rounded,
              isNumber: false,
            ),
            CustomDatePicker(ondateSelected: (value) {}),
            // TODO: INTEGRATE FUNCTIONALITY FOR THIS ADDING BUDGET
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {},
              child: Text(
                'Add',
                style: GoogleFonts.outfit(color: AppColors.textWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({super.key});

  @override
  State<CustomDropDown> createState() => CustomDropDownState();
}

class CustomDropDownState extends State<CustomDropDown> {
  List<CategoryList> budgetCategoryList = BudgetCategories().categories;
  late CategoryList _selectedCategory;
  @override
  void initState() {
    super.initState();
    _selectedCategory = budgetCategoryList.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CategoryList>(
      decoration: InputDecoration(
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
      initialValue: _selectedCategory,
      items: budgetCategoryList.map((category) {
        return DropdownMenuItem<CategoryList>(
          value: category,
          child: Text(category.name, style: GoogleFonts.outfit()),
        );
      }).toList(),
      onChanged: (value) {},
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isNumber;

  const CustomInputField({
    super.key,

    required this.hint,
    required this.icon,
    required this.isNumber,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: isNumber
          ? TextInputType.numberWithOptions(decimal: true)
          : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15),
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
