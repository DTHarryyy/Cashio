import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/model/category_model.dart';
import 'package:cashio/features/budgets/model/budget.dart';
import 'package:cashio/features/home/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BudgetCards extends StatefulWidget {
  final List<Transaction> transactions;
  final List<CategoryModel> categoriesData;
  final List<Budget> budgets;
  const BudgetCards({
    super.key,
    required this.transactions,
    required this.categoriesData,
    required this.budgets,
  });

  @override
  State<BudgetCards> createState() => _BudgetCardsState();
}

class _BudgetCardsState extends State<BudgetCards> {
  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM dd yyyy');
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 2,
    );

    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: widget.budgets.length,
        itemBuilder: (context, index) {
          // mapping category
          final categoryMap = {for (var c in widget.categoriesData) c.id: c};

          // initialize budget item
          final budget = widget.budgets[index];

          final category = categoryMap[budget.categoryId];

          double totalSpend = widget.transactions
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
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.more_vert_rounded),
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
                        style: GoogleFonts.outfit(
                          color: AppColors.textSecondary,
                        ),
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
                  value: totalSpend / 1000,
                  backgroundColor: AppColors.background,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(30),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.button),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
