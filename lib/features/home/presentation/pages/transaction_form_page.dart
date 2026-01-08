import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/model/category_model.dart';
import 'package:cashio/core/provider/category_provider.dart';
import 'package:cashio/core/utils/validators.dart';
import 'package:cashio/core/widgets/custom_date_picker.dart';
import 'package:cashio/core/widgets/custom_dropdown.dart';
import 'package:cashio/core/widgets/custom_input_field.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/features/budgets/model/budget.dart';
import 'package:cashio/features/budgets/provider/budget_provider.dart';
import 'package:cashio/features/home/model/transaction.dart';
import 'package:cashio/features/home/presentation/widget/segmented_button.dart';
import 'package:cashio/features/home/provider/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cashio/core/utils/snackbar.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:google_fonts/google_fonts.dart';

enum TransactionType { expense, income }

class AddTransactionPage extends ConsumerStatefulWidget {
  final Transaction? transaction;
  const AddTransactionPage({super.key, this.transaction});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  // Transaction input controllers
  final TextEditingController _transactionNameController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime? _date = DateTime.now();

  TransactionType _selectedType = TransactionType.expense;

  // Budget dropdown variables
  late List<Budget> _budgetList;
  Budget? _selectedBudget;
  bool isLoading = false;
  late List<Budget> selectedCategoryBudget = [];
  // Category dropdown variables
  late List<CategoryModel> _categories;
  CategoryModel? _selectedCategory;

  @override
  void dispose() {
    _amountController.dispose();
    _transactionNameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _categories = [];
  }

  void _updateCategories(List<CategoryModel> allCategories) {
    final filtered = allCategories
        .where((c) => c.type == _selectedType.name && c.name.isNotEmpty)
        .toList();

    setState(() {
      _categories = filtered;
      _selectedBudget = null;
    });
  }

  void updateBudgetsAvailable(CategoryModel selectedCategory) {
    setState(() {
      selectedCategoryBudget = _budgetList
          .where((b) => b.categoryId == selectedCategory.id)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final userAsync = ref.watch(profileProvider);

    final titleLabel = _selectedType == TransactionType.income
        ? 'Income'
        : 'Expense';
    return userAsync.when(
      error: (e, _) =>
          Scaffold(body: Center(child: Text('Error loading user: $e'))),
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
      data: (user) {
        final budgetsAsync = ref.watch(getBudgetprovider(user!.userId));
        return budgetsAsync.when(
          error: (e, stack) =>
              Scaffold(body: Center(child: Text("Budgets error: $e $stack"))),
          loading: () => Scaffold(body: Center(child: CustomLoading())),
          data: (budget) {
            _budgetList = budget;

            final categoryAsync = ref.watch(getCategoriesProvider);
            return categoryAsync.when(
              error: (e, _) =>
                  Scaffold(body: Center(child: Text('Category error: $e'))),
              loading: () => CustomLoading(),
              data: (category) {
                // Initialize categories filtered by type only on first build
                if (_categories.isEmpty) {
                  _updateCategories(category);
                }

                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: AppColors.surface,
                    elevation: 1,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      height: 40,
                      width: 200,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomSegmentButton(
                            label: 'Expenses',
                            selected: _selectedType == TransactionType.expense,
                            onTap: () {
                              _selectedType = TransactionType.expense;
                              _updateCategories(category);
                            },
                          ),
                          CustomSegmentButton(
                            label: 'Income',
                            selected: _selectedType == TransactionType.income,
                            onTap: () {
                              _selectedType = TransactionType.income;
                              _updateCategories(category);
                            },
                          ),
                        ],
                      ),
                    ),
                    centerTitle: true,
                  ),
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomInputField(
                            hint: titleLabel,
                            icon: Icons.title_rounded,
                            isNumber: false,
                            controller: _transactionNameController,
                            validator: Validators.required(titleLabel),
                          ),
                          const SizedBox(height: 12),
                          CustomInputField(
                            hint: 'Amount',
                            icon: Icons.attach_money_outlined,
                            isNumber: true,
                            controller: _amountController,
                            validator: Validators.required('Amount'),
                          ),
                          const SizedBox(height: 12),
                          CustomInputField(
                            hint: 'Notes (optional)',
                            icon: Icons.notes_rounded,
                            isNumber: false,
                            controller: _noteController,
                          ),
                          const SizedBox(height: 12),
                          // Category Dropdown
                          CustomDropdown(
                            valueChange: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedCategory = value;
                                  _selectedBudget = null;
                                  updateBudgetsAvailable(value);
                                });
                              }
                            },
                            hint: _selectedCategory != null
                                ? _selectedCategory?.name
                                : 'Select category',
                            items: _categories,
                            labelBuilder: (e) => e.name,
                            validator: (value) {
                              if (_selectedCategory == null) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 10),
                          // Budget Dropdown
                          CustomDropdown(
                            valueChange: (value) =>
                                setState(() => _selectedBudget = value),
                            hint: _selectedBudget != null
                                ? _selectedBudget!.name
                                : selectedCategoryBudget.isEmpty
                                ? _selectedCategory == null
                                      ? 'No budgets yet (optional)'
                                      : 'No budgets yet for ${_selectedCategory!.name} (optional)'
                                : "Select a budget (optional)",
                            items: selectedCategoryBudget,
                            labelBuilder: (e) => e.name,
                          ),

                          const SizedBox(height: 12),
                          CustomDatePickerFormField(
                            onDateSelected: (value) {
                              _date = value;
                            },
                            validator: Validators.dateValidator(
                              'Deadline',
                              false,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }
                              setState(() => isLoading = true);
                              try {
                                double? amount = double.parse(
                                  _amountController.text,
                                );

                                if (_selectedCategory == null) {
                                  AppSnackBar.info(
                                    context,
                                    'Please select a category',
                                  );
                                  setState(() => isLoading = false);
                                  return;
                                }

                                await ref
                                    .read(addTransactionsProvider)
                                    .call(
                                      Transaction(
                                        transactionName:
                                            _transactionNameController.text
                                                .trim(),
                                        userId: user.userId,
                                        categoryId: _selectedCategory!.id!,
                                        budgetId: _selectedBudget?.budgetId,
                                        amount: amount,
                                        type: _selectedType.name,
                                        transactionDate: _date,
                                      ),
                                    );
                                if (!context.mounted) return;
                                AppSnackBar.success(
                                  context,
                                  'Transaction added successfully',
                                );
                                Navigator.pop(context);
                              } catch (e) {
                                AppSnackBar.error(context, 'Error: $e');
                              } finally {
                                setState(() => isLoading = false);
                              }
                            },
                            child: Text(
                              isLoading
                                  ? 'Adding Transaction...'
                                  : 'Add Transaction',
                              style: GoogleFonts.outfit(
                                color: AppColors.textWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
