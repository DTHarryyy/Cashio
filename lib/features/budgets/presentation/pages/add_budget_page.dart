import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/model/category_model.dart';
import 'package:cashio/core/provider/category_provider.dart';
import 'package:cashio/core/utils/snackbar.dart';
import 'package:cashio/core/utils/validators.dart';
import 'package:cashio/core/widgets/custom_date_picker.dart';
import 'package:cashio/core/widgets/custom_dropdown.dart';
import 'package:cashio/core/widgets/custom_input_field.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:cashio/features/budgets/model/budget.dart';
import 'package:cashio/features/budgets/provider/budget_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AddBudgetPage extends ConsumerStatefulWidget {
  const AddBudgetPage({super.key});

  @override
  ConsumerState<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends ConsumerState<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  DateTime now = DateTime.now();

  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    startDate = now;
    endDate = DateTime(now.year, now.month + 1);
  }

  List<CategoryModel> categories = [];
  CategoryModel? _selectedCategoryId;
  void updateCategories(List<CategoryModel> allCategories) {
    final filtered = allCategories
        .where((c) => c.type == 'expense' && c.name.isNotEmpty)
        .toList();
    setState(() {
      categories = filtered;
    });
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
        final categoryAsync = ref.watch(getCategoriesProvider);

        return categoryAsync.when(
          error: (e, _) =>
              Scaffold(body: Center(child: Text('Budget error: $e'))),
          loading: () => Scaffold(body: Center(child: CustomLoading())),
          data: (category) {
            if (categories.isEmpty) {
              updateCategories(category);
            }
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  'Add new budget',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Form(
                    key: _formKey,
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
                          validator: Validators.required('Title'),
                        ),
                        CustomDropdown(
                          valueChange: (value) =>
                              setState(() => _selectedCategoryId = value),
                          hint: 'Please select category',
                          items: categories,
                          labelBuilder: (e) => e.name,
                          validator: (value) {
                            if (_selectedCategoryId == null) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        ),

                        CustomInputField(
                          hint: 'Amount',
                          icon: Icons.attach_money_rounded,
                          isNumber: true,
                          controller: amountController,
                          validator: Validators.numbers('Amount'),
                        ),
                        CustomInputField(
                          hint: 'Notes(optional)',
                          icon: Icons.notes_rounded,
                          isNumber: false,
                          controller: notesController,
                        ),
                        CustomDatePickerFormField(
                          onDateSelected: (value) => startDate = value,
                          validator: Validators.dateValidator(
                            'Start date',
                            true,
                          ),
                        ),
                        CustomDatePickerFormField(
                          onDateSelected: (value) => endDate = value,
                          validator: Validators.dateValidator(
                            'End date',
                            false,
                          ),
                        ),
                        // TODO: INTEGRATE FUNCTIONALITY FOR THIS ADDING BUDGET
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            try {
                              final amountValue = double.parse(
                                amountController.text,
                              );
                              await addBudget.call(
                                Budget(
                                  userId: user!.userId,
                                  name: titleController.text.trim(),
                                  totalAmount: amountValue,
                                  startDate: startDate,
                                  endDate: endDate,
                                  categoryId: _selectedCategoryId!.id!,
                                ),
                              );

                              if (!context.mounted) return;
                              AppSnackBar.success(
                                context,
                                'Budget added successfully',
                              );
                              Navigator.pop(context);
                            } catch (e) {
                              debugPrint("AddBudget error $e");
                            }
                          },
                          child: Text(
                            'Add',
                            style: GoogleFonts.outfit(
                              color: AppColors.textWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
