import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/dialog/confirm_dialog.dart';
import 'package:cashio/core/model/category_model.dart';
import 'package:cashio/core/utils/snackbar.dart';
import 'package:cashio/features/budgets/model/budget.dart';
import 'package:cashio/features/budgets/presentation/pages/budget_form_page.dart';
import 'package:cashio/features/budgets/provider/budget_provider.dart';
import 'package:cashio/features/transactions/model/transaction.dart';
import 'package:cashio/features/transactions/presentation/transaction_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class BudgetCards extends ConsumerWidget {
  final List<Transaction> transactions;
  final List<CategoryModel> categoriesData;
  final List<Budget> budgets;
  BudgetCards({
    super.key,
    required this.transactions,
    required this.categoriesData,
    required this.budgets,
  });

  final currencyFormatter = NumberFormat.currency(
    locale: 'en_PH',
    symbol: '₱',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (budgets.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: Lottie.asset(
                'assets/lottiefiles/Calculate.json',
                height: 250,

                fit: BoxFit.cover,
              ),
            ),

            Text(
              'No budgets yet!',
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'You haven’t created any budgets. Start by adding one to track your spending and reach your savings goals.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: const Color.fromARGB(255, 104, 105, 105),
              ),
            ),
          ],
        ),
      );
    }
    final categoryMap = {for (var c in categoriesData) c.id: c};

    final dateFormatter = DateFormat('MMM dd yyyy');

    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemCount: budgets.length,
      itemBuilder: (context, index) {
        // initialize budget item
        final budget = budgets[index];

        final category = categoryMap[budget.categoryId];

        double totalSpend = transactions
            .where((t) => t.budgetId == budget.budgetId)
            .fold(0, (sum, t) => sum + t.amount);

        // variables for ui / display
        final categoryIcon = category?.icon ?? Icons.help_rounded;
        final categoryName = category?.name ?? 'Other';
        final categoryColor =
            category?.color ?? const Color.fromARGB(255, 221, 158, 135);

        final title = budget.name;
        final amount = currencyFormatter.format(budget.totalAmount);
        final date = dateFormatter.format(budget.createdAt!);

        final spendPecentage = (totalSpend / budget.totalAmount) * 100;
        final totalRemaining = currencyFormatter.format(
          budget.totalAmount - totalSpend,
        );

        return Container(
          key: ValueKey(budget.budgetId),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                spacing: 10,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: categoryColor.withAlpha(60),
                    ),
                    child: Icon(categoryIcon, color: categoryColor),
                  ),
                  Expanded(
                    child: Text(
                      title.toUpperCase(),
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  MenuAnchor(
                    alignmentOffset: Offset(-43, 0),

                    builder:
                        (
                          BuildContext context,
                          MenuController controller,
                          Widget? child,
                        ) {
                          return IconButton(
                            icon: Icon(
                              controller.isOpen
                                  ? Icons.close_rounded
                                  : Icons.more_horiz_rounded,
                              size: 18,
                            ),
                            onPressed: () {
                              controller.isOpen
                                  ? controller.close()
                                  : controller.open();
                            },
                          );
                        },
                    style: MenuStyle(
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 0),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        AppColors.surface,
                      ),
                    ),
                    menuChildren: [
                      MenuItemButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionFormPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Add expenses',
                          style: GoogleFonts.outfit(),
                        ),
                      ),
                      MenuItemButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddBudgetPage(budget: budget),
                            ),
                          );
                        },
                        child: Text('Edit budget', style: GoogleFonts.outfit()),
                      ),
                      MenuItemButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ConfirmDialog(
                              title: 'Delete Budget',
                              btnText: 'Delete',
                              onConfirm: () async {
                                await ref
                                    .read(deleteBudgetProvider)
                                    .call(budget.budgetId!);
                                if (!context.mounted) return;
                                AppSnackBar.success(
                                  context,
                                  'Budget successfully deleted',
                                );
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Delete budget',
                          style: GoogleFonts.outfit(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                height: 1,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      totalRemaining.toString(),
                      style: GoogleFonts.outfit(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(date, style: GoogleFonts.outfit()),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Remaining from $amount',
                      style: GoogleFonts.outfit(color: AppColors.textSecondary),
                    ),
                  ),
                  Text(
                    'creataed on',
                    style: GoogleFonts.outfit(color: AppColors.textSecondary),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Text('Amount spent', style: GoogleFonts.outfit()),
                  ),
                  Text(categoryName, style: GoogleFonts.outfit()),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      currencyFormatter.format(totalSpend),
                      style: GoogleFonts.outfit(),
                    ),
                  ),
                  Text('$spendPecentage%', style: GoogleFonts.outfit()),
                ],
              ),
              SizedBox(height: 5),
              LinearProgressIndicator(
                value: totalSpend / budget.totalAmount,
                backgroundColor: AppColors.background,
                minHeight: 10,
                borderRadius: BorderRadius.circular(30),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.button),
              ),
            ],
          ),
        );
      },
    );
  }
}
