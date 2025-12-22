import 'package:cashio/core/constant/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BarGraph extends ConsumerWidget {
  const BarGraph({super.key});
  List<String> getLast3Months() {
    final now = DateTime.now();

    return List.generate(3, (index) {
      final date = DateTime(now.year, now.month - index, 1);
      return DateFormat('MMM').format(date);
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final months = getLast3Months();
    return BarChart(
      BarChartData(
        minY: 0,
        maxY: 6,

        barTouchData: BarTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            getTooltipItem:
                (
                  BarChartGroupData group,
                  int groupIndex,
                  BarChartRodData rod,
                  int rodIndex,
                ) {
                  final isIncome = rodIndex == 0;

                  return BarTooltipItem(
                    '${isIncome ? 'Income' : 'Expense'}\n'
                    '₱${rod.toY.toStringAsFixed(0)}',
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

        barGroups: List.generate(months.length, (index) {
          return BarChartGroupData(
            x: index,
            barsSpace: 6,
            barRods: [
              BarChartRodData(
                toY: 5,
                width: 7,
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF70E49A),
              ),
              BarChartRodData(
                toY: 2,
                width: 7,
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFFA7575),
              ),
            ],
          );
        }),
      ),
    );
  }
}
