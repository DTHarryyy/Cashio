import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/utils/list_categories.dart';
import 'package:cashio/core/utils/snackbar.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:cashio/features/budgets/model/budget_model.dart';
import 'package:cashio/features/budgets/provider/budget_provider.dart';
import 'package:cashio/features/home/provider/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AddBudgetPage extends ConsumerStatefulWidget {
  const AddBudgetPage({super.key});

  @override
  ConsumerState<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends ConsumerState<AddBudgetPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  List<CategoryList> budgetCategoryList = BudgetCategories().categories;

  CategoryList selectedCategory = BudgetCategories().categories.first;

  @override
  void initState() {
    super.initState();
    selectedCategory = budgetCategoryList.first;
  }

  @override
  Widget build(BuildContext context) {
    final addBudget = ref.read(addNewBudgetProvider);
    final userAsync = ref.watch(profileProvider);

    return userAsync.when(
      // TODO: Throw to error page run time error page
      error: (e, _) =>
          Scaffold(body: Center(child: Text('There must be an error'))),
      loading: () => Scaffold(body: Center(child: CustomLoading())),
      data: (user) {
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
                  controller: titleController,
                ),
                CustomDropDown(
                  selectedCategory: selectedCategory,
                  onChange: (value) {},
                  budgetCategoryList: budgetCategoryList,
                ),
                CustomInputField(
                  hint: 'Amount',
                  icon: Icons.attach_money_rounded,
                  isNumber: true,
                  controller: amountController,
                ),
                CustomInputField(
                  hint: 'Notes(optional)',
                  icon: Icons.notes_rounded,
                  isNumber: false,
                  controller: notesController,
                ),
                // TODO: INTEGRATE FUNCTIONALITY FOR THIS ADDING BUDGET
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () async {
                    final double? amountValue = double.tryParse(
                      amountController.text,
                    );
                    try {
                      final categoryId = await ref
                          .read(addCategoriesProvider)
                          .call(
                            user.userId,
                            selectedCategory.name,
                            'budget',
                            selectedCategory.icon,
                            selectedCategory.color,
                          );
                      await addBudget.call(
                        BudgetModel(
                          userId: user.userId,
                          title: titleController.text.trim(),
                          amount: amountValue!,
                          categoryId: categoryId,
                        ),
                      );
                      if (!context.mounted) return;
                      AppSnackBar.success(context, 'Budget added successfully');
                      Navigator.pop(context);
                    } catch (e) {
                      debugPrint("AddBudget error $e");
                    }
                  },
                  child: Text(
                    'Add',
                    style: GoogleFonts.outfit(color: AppColors.textWhite),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomDropDown extends StatelessWidget {
  final CategoryList? selectedCategory;
  final ValueChanged<CategoryList?> onChange;
  final List<CategoryList> budgetCategoryList;

  const CustomDropDown({
    super.key,
    required this.selectedCategory,
    required this.onChange,
    required this.budgetCategoryList,
  });

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
      initialValue: selectedCategory,
      items: budgetCategoryList.map((category) {
        return DropdownMenuItem<CategoryList>(
          value: category,
          child: Text(category.name, style: GoogleFonts.outfit()),
        );
      }).toList(),
      onChanged: onChange,
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isNumber;
  final TextEditingController controller;

  const CustomInputField({
    super.key,
    required this.hint,
    required this.icon,
    required this.isNumber,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
