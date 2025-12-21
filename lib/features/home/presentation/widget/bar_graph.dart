import 'package:cashio/core/constant/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BarGraph extends StatelessWidget {
  const BarGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mar'];

    return BarChart(
      BarChartData(
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

        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  months[value.toInt()],
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: AppColors.border,
                  ),
                ),
              ),
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: List.generate(3, (index) {
          return BarChartGroupData(
            x: index,
            barsSpace: 4,
            barRods: [
              BarChartRodData(
                toY: 5,
                width: 6,
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFF70E49A),
              ),
              BarChartRodData(
                toY: 2,
                width: 6,
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFFFA7575),
              ),
            ],
          );
        }),
      ),
      swapAnimationDuration: const Duration(milliseconds: 500),
      swapAnimationCurve: Curves.easeOutCubic,
    );
  }
}
