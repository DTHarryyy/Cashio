import 'package:cashio/core/model/category_model.dart';
import 'package:cashio/core/provider/category_provider.dart';
import 'package:cashio/core/widgets/custom_button.dart';
import 'package:cashio/core/widgets/custom_date_picker.dart';
import 'package:cashio/core/widgets/custom_dropdown.dart';
import 'package:cashio/core/widgets/custom_input_field.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/features/budgets/model/budget.dart';
import 'package:cashio/features/budgets/provider/budget_provider.dart';
import 'package:cashio/features/dashboard/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionEditFormPage extends ConsumerStatefulWidget {
  final Transaction? transaction;
  const TransactionEditFormPage({super.key, this.transaction});

  @override
  ConsumerState<TransactionEditFormPage> createState() =>
      _TransactionEditFormPageState();
}

class _TransactionEditFormPageState
    extends ConsumerState<TransactionEditFormPage> {
  // Initialize controllers
  late TextEditingController transacNameController;
  late TextEditingController amountController;
  late TextEditingController notesController;

  late String selectedCategory;
  late String? selectedBudget;
  late DateTime selectedDate;

  // Initialize variables for dropdown
  List<CategoryModel> categoryItems = [];
  List<Budget> budgetItems = [];

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

    selectedCategory = widget.transaction!.categoryId;
    selectedBudget = widget.transaction?.budgetId;
    selectedDate = widget.transaction?.transactionDate ?? DateTime.now();
  }

  void updateCategories(List<CategoryModel> categories) {
    final filtered = categories
        .where((c) => c.type == widget.transaction?.type)
        .toList();
    setState(() {
      categoryItems = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryAsync = ref.watch(getCategoriesProvider);
    final budgetAsync = ref.watch(
      getBudgetprovider(widget.transaction?.userId ?? ''),
    );
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
              appBar: AppBar(title: const Text('Edit Transaction')),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    CustomInputField(
                      hint: 'Transaction Name',
                      icon: Icons.title,
                      isNumber: false,
                      controller: transacNameController,
                    ),
                    CustomInputField(
                      hint: 'Amount',
                      icon: Icons.title,
                      isNumber: false,
                      controller: amountController,
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
                              (cat) => cat.id == widget.transaction!.categoryId,
                            )
                          : null,
                      valueChange: (value) {},
                      hint: 'Select Category',
                      items: categoryItems,
                      labelBuilder: (value) => value.name,
                    ),
                    if (widget.transaction != null &&
                        widget.transaction!.type == 'expense')
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
                      initialDate: selectedDate,
                      onDateSelected: (value) =>
                          setState(() => selectedDate = value),
                    ),
                    CustomButton(
                      hint: 'Update',
                      onPressed: () {
                        // TODO: Implement update functionality
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
