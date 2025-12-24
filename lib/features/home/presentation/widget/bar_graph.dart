import 'package:cashio/core/constant/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cashio/features/home/model/monthly_total.dart';

class BarGraph extends ConsumerWidget {
  final List<MonthlyTotal> monthlyTotal;

  const BarGraph({super.key, required this.monthlyTotal});

  // Generate last 3 months labels
  List<String> getLast3Months() {
    final now = DateTime.now();
    return List.generate(3, (index) {
      final date = DateTime(now.year, now.month - index, 1);
      return DateFormat('MMM').format(date);
    }).reversed.toList();
  }

  // Map MonthlyTotal into BarChartGroupData
  List<BarChartGroupData> getBarGroups() {
    // Group by month
    final grouped = <String, Map<String, double>>{};

    for (final t in monthlyTotal) {
      final monthKey = DateFormat('MMM').format(t.month);
      grouped[monthKey] ??= {'income': 0.0, 'expense': 0.0};
      grouped[monthKey]![t.categoryType] = t.total;
    }

    // Keep only months that have at least income or expense
    final monthsWithData = grouped.entries
        .where(
          (entry) =>
              (entry.value['income'] ?? 0) > 0 ||
              (entry.value['expense'] ?? 0) > 0,
        )
        .toList();

    return List.generate(monthsWithData.length, (index) {
      final income = monthsWithData[index].value['income']!;
      final expense = monthsWithData[index].value['expense']!;

      return BarChartGroupData(
        x: index,
        barsSpace: 6,
        barRods: [
          BarChartRodData(
            toY: income,
            width: 7,
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFF70E49A),
          ),
          BarChartRodData(
            toY: expense,
            width: 7,
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFFA7575),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Group monthly totals
    final grouped = <String, Map<String, double>>{};
    for (final t in monthlyTotal) {
      final monthKey = DateFormat('MMM').format(t.month);
      grouped[monthKey] ??= {'income': 0.0, 'expense': 0.0};
      grouped[monthKey]![t.categoryType] = t.total;
    }

    // Filter months with at least one non-zero value
    final monthsWithData = grouped.entries
        .where(
          (entry) =>
              (entry.value['income'] ?? 0) > 0 ||
              (entry.value['expense'] ?? 0) > 0,
        )
        .toList();

    // X-axis labels
    final months = monthsWithData.map((e) => e.key).toList();

    // Bar groups
    final barGroups = List.generate(monthsWithData.length, (index) {
      final income = monthsWithData[index].value['income']!;
      final expense = monthsWithData[index].value['expense']!;
      return BarChartGroupData(
        x: index,
        barsSpace: 6,
        barRods: [
          BarChartRodData(
            toY: income,
            width: 7,
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFF70E49A),
          ),
          BarChartRodData(
            toY: expense,
            width: 7,
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFFA7575),
          ),
        ],
      );
    });

    return BarChart(
      BarChartData(
        minY: 0,
        barGroups: barGroups,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final index = value.toInt();
                if (index < 0 || index >= months.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    months[index],
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: AppColors.border,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        barTouchData: BarTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final isIncome = rodIndex == 0;
              return BarTooltipItem(
                '${isIncome ? 'Income' : 'Expense'}\n₱${rod.toY.toStringAsFixed(0)}',
                const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
