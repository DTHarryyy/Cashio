import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/features/auth/model/app_user.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:cashio/features/home/model/transactions.dart';
import 'package:cashio/features/home/provider/transactions_provider.dart';
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
          getTransactionsProvider(user.userId),
        );

        return transactionAsync.when(
          error: (e, _) => Text('There must be an errorr'),
          loading: () => Container(color: AppColors.surface),
          data: (transactions) {
            if (transactions.isEmpty) {
              return const Text('no expenses yet');
            }
            return _transactionsContent(context, transactions, user);
          },
        );
      },
    );
  }

  Widget _transactionsContent(
    BuildContext context,
    List<Transactions> transactions,
    AppUser user,
  ) {
    return ListView.separated(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final name = transaction.name.toUpperCase();
        final amount = transaction.amount.toString();

        final formatter = DateFormat('MMM dd yyyy ');
        final date = formatter.format(transaction.transactionDate);

        final categoryType = transaction.categoryType;
        final categoryName = transaction.categoryName;
        final categoryIcon = transaction.categoryIcon;
        final categoryColor = transaction.categoryColor;

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
