import 'dart:math';

import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/model/category_model.dart';
import 'package:cashio/core/provider/category_provider.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/features/auth/model/app_user.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:cashio/features/transactions/model/transaction.dart';
import 'package:cashio/features/transactions/provider/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RecentTransactions extends ConsumerWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      error: (error, stackTrace) => Center(
        child: Text('youre not logged in', style: GoogleFonts.outfit()),
      ),
      loading: () => Center(child: CustomLoading()),
      data: (user) {
        // transactions  provider
        final transactionAsync = ref.watch(
          getAllTransactionsProvider(user!.userId),
        );

        final categoryAsync = ref.watch(getCategoriesProvider);

        return categoryAsync.when(
          error: (e, _) =>
              Scaffold(body: Center(child: Text('category error: $e'))),
          loading: () => Scaffold(body: Center(child: CustomLoading())),
          data: (categoryData) {
            return transactionAsync.when(
              error: (e, _) => Text('There must be an error $e'),
              loading: () => Container(color: AppColors.surface),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'No transactions yet!',
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Your income and expense records will appear here once you start adding transactions.',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 104, 105, 105),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }
                return _transactionsContent(
                  context,
                  categoryData,
                  transactions,
                  user,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _transactionsContent(
    BuildContext context,
    List<CategoryModel> categoryData,
    List<Transaction> transactions,
    AppUser user,
  ) {
    return ListView.separated(
      itemCount: min(transactions.length, 10),
      itemBuilder: (context, index) {
        final categoryMap = {for (var c in categoryData) c.id: c};
        final transaction = transactions[index];
        final category = categoryMap[transaction.categoryId];
        final name = transaction.transactionName?.toUpperCase() ?? '';
        final amount = transaction.amount.toString();

        final formatter = DateFormat('MMM dd yyyy');
        final date = formatter.format(
          transaction.transactionDate ?? DateTime.now(),
        );
        final categoryType = transaction.type;

        final categoryName = category?.name ?? 'dsasd';
        final categoryIcon = category?.icon ?? Icons.help_rounded;
        final categoryColor =
            category?.color ?? const Color.fromARGB(255, 221, 158, 135);

        final isIncome = categoryType == 'income';

        return Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          child: ListTile(
            leading: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: categoryColor.withAlpha(80),
              ),

              child: Icon(categoryIcon),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  isIncome ? '+₱$amount' : '-₱$amount',
                  style: GoogleFonts.outfit(
                    color: isIncome ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),

                  child: Text(
                    categoryName,
                    style: GoogleFonts.outfit(color: AppColors.surface),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 5),
    );
  }
}
