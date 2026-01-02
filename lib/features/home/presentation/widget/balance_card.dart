import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/features/home/model/monthly_total.dart';
import 'package:cashio/features/home/presentation/widget/bar_graph.dart';
import 'package:cashio/features/home/presentation/widget/stat_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BalanceCard extends ConsumerWidget {
  final double income;
  final double expenses;
  final double totalBalance;
  final List<MonthlyTotal> monthlyTotal;
  const BalanceCard({
    super.key,
    required this.income,
    required this.expenses,
    required this.totalBalance,
    required this.monthlyTotal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 2,
    );
    return Container(
      height: 200,
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
                      value: currencyFormatter.format(income).toString(),
                    ),
                    const SizedBox(height: 6),
                    StatRow(
                      icon: Icons.arrow_downward,
                      color: AppColors.error,
                      label: 'Expense',
                      value: currencyFormatter.format(expenses).toString(),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Chart
                Expanded(child: BarGraph(monthlyTotal: monthlyTotal)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
