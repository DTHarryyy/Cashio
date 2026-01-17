import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/features/auth/provider/current_user_profile.dart';
import 'package:cashio/features/dashboard/provider/analytics_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AccountOverview extends ConsumerWidget {
  const AccountOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserProfileProvider)!.userId;
    final monthlyAsync = ref.watch(getMonthlyOverviewProvider(userId));

    return monthlyAsync.when(
      loading: () => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const AspectRatio(aspectRatio: 1 / 1),
      ),
      error: (e, _) => Center(child: Text('Account overview error: $e')),
      data: (monthly) {
        // Create chart spots dynamically
        final incomeSpots = monthly.asMap().entries.map((entry) {
          final index = entry.key.toDouble();
          final month = entry.value;
          return FlSpot(index, month.income.toDouble());
        }).toList();

        final expenseSpots = monthly.asMap().entries.map((entry) {
          final index = entry.key.toDouble();
          final month = entry.value;
          return FlSpot(index, month.expense.toDouble());
        }).toList();

        // TODO: integrate balace  in accoutn overview when needed
        // final balanceSpots = monthly.asMap().entries.map((entry) {
        //   final index = entry.key.toDouble();
        //   final month = entry.value;
        //   return FlSpot(index, month.balance.toDouble());
        // }).toList();

        // Calculate dynamic maxY for chart to prevent overflow
        final maxIncome = monthly
            .map((m) => m.income)
            .reduce((a, b) => a > b ? a : b);
        final maxExpense = monthly
            .map((m) => m.expense)
            .reduce((a, b) => a > b ? a : b);
        final maxBalance = monthly
            .map((m) => m.balance)
            .reduce((a, b) => a > b ? a : b);
        final maxY =
            [
              maxIncome,
              maxExpense,
              maxBalance,
            ].reduce((a, b) => a > b ? a : b) *
            1.1;

        return Container(
          padding: const EdgeInsets.only(top: 15, right: 20, bottom: 15),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                'Account Overview',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Balance: ${monthly.last.balance.toString()}',
                style: GoogleFonts.outfit(fontSize: 14),
              ),
              const SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 1.5,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: maxY,
                    clipData: FlClipData.all(),
                    borderData: FlBorderData(show: false),
                    lineTouchData: LineTouchData(enabled: true),
                    lineBarsData: [
                      // Income line
                      LineChartBarData(
                        spots: incomeSpots,
                        isCurved: true,
                        barWidth: 2,
                        color: AppColors.success,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.success,
                              AppColors.surface.withAlpha(60),
                            ],
                          ),
                        ),
                      ),
                      // Expense line
                      LineChartBarData(
                        spots: expenseSpots,
                        isCurved: true,
                        barWidth: 2,
                        color: AppColors.error,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.error,
                              AppColors.surface.withAlpha(60),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // betweenBarsData: [
                    //   BetweenBarsData(
                    //     fromIndex: 0,
                    //     toIndex: 1,
                    //     color: const Color.fromARGB(255, 151, 246, 230),
                    //   ),
                    // ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= monthly.length) {
                              return const SizedBox();
                            }
                            final monthName = DateFormat.MMM().format(
                              monthly[index].monthStart,
                            );
                            return SideTitleWidget(
                              meta: meta,
                              space: 4,
                              child: Text(
                                monthName,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
