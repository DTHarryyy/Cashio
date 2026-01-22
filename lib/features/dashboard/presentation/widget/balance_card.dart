import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/features/auth/provider/current_user_profile.dart';
import 'package:cashio/features/dashboard/model/balance.dart';
import 'package:cashio/features/dashboard/presentation/pages/finance_pie_chart.dart';
import 'package:cashio/features/dashboard/presentation/widget/stat_row.dart';
import 'package:cashio/features/dashboard/provider/balance_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserProfileProvider)!.userId;
    final balanceAsync = ref.watch(getBalanceProvider(userId));

    // TODO: do a skeleton laoding
    return balanceAsync.when(
      error: (e, _) => Text('Balance error: $e'),
      loading: () => CustomLoading(),
      data: (balance) {
        return balanceContents(context, balance);
      },
    );
  }

  Widget balanceContents(BuildContext context, Balance? balance) {
    // double totalBalance = balance.first.totalBalance ;
    // double totalIncome = balance.first.totalIncome;
    // double totalExpenses = balance.first.totalExpenses;

    double totalIncome = balance?.totalIncome ?? 0.0;
    double totalExpenses = balance?.totalExpenses ?? 0.0;
    double totalBalance = totalIncome - totalExpenses;

    final currencyFormatter = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 2,
    );
    return Container(
      constraints: BoxConstraints(maxHeight: 230),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            const Color.fromARGB(255, 139, 64, 238).withAlpha(95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: GoogleFonts.outfit(color: AppColors.border, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            currencyFormatter.format(totalBalance).toString(),
            style: GoogleFonts.outfit(
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                // Income / Expense
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatRow(
                      icon: Icons.arrow_upward,
                      color: AppColors.success,
                      label: 'income',
                      value: currencyFormatter.format(totalIncome).toString(),
                    ),
                    const SizedBox(height: 6),
                    StatRow(
                      icon: Icons.arrow_downward,
                      color: AppColors.error,
                      label: 'Expense',
                      value: currencyFormatter.format(totalExpenses).toString(),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Chart
                Expanded(
                  child: FinancePieChart(
                    income: 123,
                    expense: 123,
                    savings: 123,
                    balance: 123,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
