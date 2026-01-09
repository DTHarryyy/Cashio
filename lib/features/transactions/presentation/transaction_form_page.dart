import 'package:cashio/core/model/category_model.dart';
import 'package:cashio/core/provider/category_provider.dart';
import 'package:cashio/core/utils/snackbar.dart';
import 'package:cashio/core/utils/validators.dart';
import 'package:cashio/core/widgets/custom_button.dart';
import 'package:cashio/core/widgets/custom_date_picker.dart';
import 'package:cashio/core/widgets/custom_dropdown.dart';
import 'package:cashio/core/widgets/custom_input_field.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/features/auth/provider/current_user_profile.dart';
import 'package:cashio/features/budgets/model/budget.dart';
import 'package:cashio/features/budgets/provider/budget_provider.dart';
import 'package:cashio/features/dashboard/model/transaction.dart';
import 'package:cashio/features/transactions/provider/transactions_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

enum TransactionType { income, expense }

class TransactionFormPage extends ConsumerStatefulWidget {
  final Transaction? transaction;
  const TransactionFormPage({super.key, this.transaction});

  @override
  ConsumerState<TransactionFormPage> createState() =>
      _TransactionFormPageState();
}

class _TransactionFormPageState extends ConsumerState<TransactionFormPage> {
  // Global form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Initialize controllers
  late TextEditingController transacNameController;
  late TextEditingController amountController;
  late TextEditingController notesController;

  late String? selectedCategory;
  late String? selectedBudget;
  late DateTime selectedDate;

  // Initialize variables for dropdown
  List<CategoryModel> categoryItems = [];
  List<Budget> budgetItems = [];

  TransactionType selectedTransactionType = TransactionType.expense;

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    transacNameController = TextEditingController(
      text: widget.transaction?.transactionName ?? '',
    );
    amountController = TextEditingController(
      text: widget.transaction != null
          ? widget.transaction!.amount.toString()
          : '',
    );
    notesController = TextEditingController(
      text: widget.transaction?.description ?? '',
    );

    selectedCategory = widget.transaction?.categoryId;
    selectedBudget = widget.transaction?.budgetId;
    selectedDate = widget.transaction?.transactionDate ?? DateTime.now();
  }

  void updateCategories(List<CategoryModel> categories) {
    final filtered = categories
        .where(
          (c) =>
              c.type == widget.transaction?.type ||
              c.type == selectedTransactionType.name,
        )
        .toList();
    setState(() {
      categoryItems = filtered;
    });
  }

  Future<void> onSubmit(String userId) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => isLoading = true);
    final amount = double.parse(amountController.text.trim());

    final newTransaction = Transaction(
      id: widget.transaction?.id,
      transactionName: transacNameController.text.trim(),
      userId: userId,
      categoryId: selectedCategory!,
      amount: amount,
      type: selectedTransactionType.name,
      description: notesController.text.trim(),
      budgetId: selectedBudget,
      transactionDate: selectedDate,
    );

    // update transaction

    if (widget.transaction == null) {
      await ref.read(addTransactionsProvider).call(newTransaction);
    } else {
      await ref.read(updateTransactionProvider).call(newTransaction);
    }

    if (!mounted) return;
    AppSnackBar.success(
      context,
      widget.transaction == null
          ? 'Transaction added successfully'
          : 'Transaction udated successfully',
    );
    Navigator.pop(context);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final categoryAsync = ref.watch(getCategoriesProvider);
    final userProfile = ref.watch(currentUserProfileProvider);
    final userId = userProfile!.userId;
    final budgetAsync = ref.watch(getBudgetprovider(userId));
    return budgetAsync.when(
      error: (e, _) =>
          Scaffold(body: Center(child: Text('Error loading budgets: $e'))),
      loading: () => Scaffold(body: Center(child: CustomLoading())),
      data: (budget) {
        budgetItems = budget;
        return categoryAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error loading categories: $e')),
          data: (categories) {
            updateCategories(categories);
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: widget.transaction == null
                    ? CupertinoSlidingSegmentedControl(
                        groupValue: selectedTransactionType,
                        children: {
                          TransactionType.expense: Text(
                            'Expense',
                            style: GoogleFonts.outfit(),
                          ),
                          TransactionType.income: Text(
                            'Income',
                            style: GoogleFonts.outfit(),
                          ),
                        },
                        onValueChanged: (value) =>
                            setState(() => selectedTransactionType = value!),
                      )
                    : Text(
                        'Edit Transaction',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        CustomInputField(
                          hint: 'Transaction Name',
                          icon: Icons.title,
                          isNumber: false,
                          controller: transacNameController,
                          validator: Validators.required('Transaction Name'),
                        ),
                        CustomInputField(
                          hint: 'Amount',
                          icon: Icons.title,
                          isNumber: true,
                          controller: amountController,
                          validator: Validators.numbers('Amount'),
                        ),
                        CustomInputField(
                          hint: 'Notes(Optional)',
                          icon: Icons.title,
                          isNumber: false,
                          controller: notesController,
                        ),
                        CustomDropdown(
                          initialValue: widget.transaction?.categoryId != null
                              ? categoryItems.firstWhere(
                                  (cat) =>
                                      cat.id == widget.transaction!.categoryId,
                                )
                              : null,
                          valueChange: (value) =>
                              setState(() => selectedCategory = value.id),
                          hint: 'Select Category',
                          items: categoryItems,
                          labelBuilder: (value) => value.name,
                          validator: Validators.dropDownRequire('Category'),
                        ),
                        if (widget.transaction != null &&
                                widget.transaction!.type == 'expense' ||
                            widget.transaction == null &&
                                selectedTransactionType ==
                                    TransactionType.expense)
                          CustomDropdown(
                            initialValue: widget.transaction?.budgetId != null
                                ? budgetItems.firstWhere(
                                    (budget) =>
                                        budget.budgetId ==
                                        widget.transaction!.budgetId,
                                  )
                                : null,
                            valueChange: (value) {},
                            hint: 'Select Budget(Optional)',
                            items: budgetItems,
                            labelBuilder: (value) => value.name,
                          ),
                        CustomDatePickerFormField(
                          initialDate: widget.transaction?.transactionDate,
                          onDateSelected: (value) =>
                              setState(() => selectedDate = value),
                          validator: Validators.dateRequired(
                            'Transaction Date',
                          ),
                        ),
                        CustomButton(
                          hint: widget.transaction == null
                              ? isLoading
                                    ? 'Adding..'
                                    : 'Add'
                              : isLoading
                              ? 'Updating..'
                              : 'Update',
                          onPressed: () => onSubmit(userId),
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
