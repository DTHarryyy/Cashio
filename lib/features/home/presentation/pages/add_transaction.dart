import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/utils/list_categories.dart';
import 'package:cashio/core/widgets/custom_date_picker.dart';
import 'package:cashio/features/home/presentation/widget/segmented_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cashio/core/utils/snackbar.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:cashio/features/home/provider/transactions_provider.dart';
import 'package:google_fonts/google_fonts.dart';

enum TransactionType { expenses, income }

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final TextEditingController _transactionNameController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime? _date;

  TransactionType _selectedType = TransactionType.expenses;
  late CategoryList _selectedCategory;
  late List<CategoryList> _currentSelectedCategory;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _currentSelectedCategory = _selectedType == TransactionType.expenses
        ? ExpenseCategories().categories
        : IncomeCategories().categories;
    _selectedCategory = _currentSelectedCategory.first;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _transactionNameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(profileProvider);

    return userAsync.when(
      data: (user) {
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
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
                    selected: _selectedType == TransactionType.expenses,
                    onTap: () {
                      setState(() {
                        _selectedType = TransactionType.expenses;
                        _currentSelectedCategory =
                            ExpenseCategories().categories;
                        _selectedCategory = _currentSelectedCategory.first;
                      });
                    },
                  ),
                  CustomSegmentButton(
                    label: 'Income',
                    selected: _selectedType == TransactionType.income,
                    onTap: () {
                      setState(() {
                        _selectedType = TransactionType.income;
                        _currentSelectedCategory =
                            IncomeCategories().categories;
                        _selectedCategory = _currentSelectedCategory.first;
                      });
                    },
                  ),
                ],
              ),
            ),

            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  autofocus: false,
                  controller: _transactionNameController,
                  decoration: InputDecoration(
                    hintText: _selectedType == TransactionType.income
                        ? 'Income'
                        : 'Expenses',
                    filled: true,
                    fillColor: AppColors.border,
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  autofocus: false,
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: 'Amount',
                    prefixText: '₱',
                    filled: true,
                    fillColor: AppColors.border,
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  autofocus: false,
                  controller: _noteController,
                  decoration: InputDecoration(
                    hintText: 'Note (optional)',
                    filled: true,
                    fillColor: AppColors.border,
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<CategoryList>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.border,
                    border: InputBorder.none,
                  ),
                  items: _currentSelectedCategory.map((category) {
                    return DropdownMenuItem<CategoryList>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 12),
                CustomDatePicker(
                  ondateSelected: (value) {
                    _date = value;
                  },
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () async {
                    setState(() => isLoading = true);
                    try {
                      double? amount = double.tryParse(_amountController.text);
                      if (amount == null) {
                        AppSnackBar.info(
                          context,
                          'Please enter a valid amount',
                        );
                        return;
                      }
                      final categoryId = await ref
                          .read(addCategoriesProvider)
                          .call(
                            user.userId,
                            _selectedCategory.name,
                            _selectedType.name,
                            _selectedCategory.icon,
                            _selectedCategory.color,
                          );

                      await ref
                          .read(addTransactionsProvider)
                          .call(
                            transactionName: _transactionNameController.text
                                .trim(),
                            userId: user.userId,
                            amount: amount,
                            categoryId: categoryId,
                            note: _noteController.text.trim(),
                            transactionDate: _date,
                          );
                      ref.invalidate(combinedTransactionsProvider(user.userId));
                      ref.invalidate(getCategoriesProvider(user.userId));
                      ref.invalidate(monthlyTotalProvider(user.userId));
                      ref.invalidate(
                        totalTransactionsProvider((
                          userId: user.userId,
                          categoryType: 'income',
                        )),
                      );
                      ref.invalidate(
                        totalTransactionsProvider((
                          userId: user.userId,
                          categoryType: 'expenses',
                        )),
                      );
                      ref.invalidate(
                        getRecentTransactionsProvider(user.userId),
                      );
                      if (!context.mounted) return;
                      AppSnackBar.success(
                        context,
                        'Transaction added successfully',
                      );
                      Navigator.pop(context);
                      setState(() => isLoading = false);
                    } catch (e) {
                      AppSnackBar.error(context, 'Error: $e');
                    }
                  },
                  child: Text(
                    isLoading ? 'Adding Transaction...' : 'Add Transaction',
                    style: GoogleFonts.outfit(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (e, _) =>
          Scaffold(body: Center(child: Text('There must be an error'))),
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
