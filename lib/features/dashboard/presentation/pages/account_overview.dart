import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/features/auth/provider/current_user_profile.dart';
import 'package:cashio/features/dashboard/model/account_overview.dart';
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
        final chartData = monthly.isNotEmpty
            ? monthly
            : List.generate(12, (index) => MonthlyOverview.empty());

        final incomeSpots = chartData.asMap().entries.map((entry) {
          final index = entry.key.toDouble();
          final month = entry.value;
          return FlSpot(index, month.income.toDouble());
        }).toList();

        final expenseSpots = chartData.asMap().entries.map((entry) {
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

        final maxIncome = chartData.fold<double>(
          0,
          (prev, m) => m.income > prev ? m.income : prev,
        );
        final maxExpense = chartData.fold<double>(
          0,
          (prev, m) => m.expense > prev ? m.expense : prev,
        );

        final maxY =
            [maxIncome, maxExpense].reduce((a, b) => a > b ? a : b) * 1.1;

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
              const SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 1.5,
                child: Stack(
                  children: [
                    LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: maxY,
                        clipData: FlClipData.all(),
                        borderData: FlBorderData(
                          show: true,
                          border: const Border(
                            left: BorderSide(color: Colors.grey, width: 0.5),
                            bottom: BorderSide(color: Colors.grey, width: 0.5),
                          ),
                        ),
                        lineTouchData: LineTouchData(
                          enabled: monthly.isNotEmpty,
                        ),
                        lineBarsData: monthly.isNotEmpty
                            ? [
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
                                        AppColors.success.withAlpha(30),
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
                                        AppColors.error.withAlpha(30),
                                        AppColors.surface.withAlpha(60),
                                      ],
                                    ),
                                  ),
                                ),
                              ]
                            : [], // empty if no data
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index < 0 || index >= chartData.length) {
                                  return const SizedBox();
                                }
                                final monthName = DateFormat.MMM().format(
                                  chartData[index].monthStart,
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
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(show: monthly.isNotEmpty),
                      ),
                    ),
                    if (!monthly.any((m) => m.income > 0 || m.expense > 0))
                      Center(
                        child: Text(
                          'No transactions yet',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
