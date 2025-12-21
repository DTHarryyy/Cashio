import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarGraph extends StatelessWidget {
  const BarGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final months = ['jan', 'feb', 'march'];

    // TODO: change data to dynamic base obn the per month  expoenses and incomeof the user
    // TODO: add also a hover and clickable datab for the rod data
    return BarChart(
      BarChartData(
        minY: 0,
        maxY: 5, // change this to highest in expenses
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  months[value.toInt()],
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: 5,
                color: const Color.fromARGB(255, 112, 228, 154),
              ),
              BarChartRodData(
                toY: 2,
                color: const Color.fromARGB(255, 250, 117, 117),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: 5,
                color: const Color.fromARGB(255, 112, 228, 154),
              ),
              BarChartRodData(
                toY: 2,
                color: const Color.fromARGB(255, 250, 117, 117),
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: 5,
                color: const Color.fromARGB(255, 112, 228, 154),
              ),
              BarChartRodData(
                toY: 2,
                color: const Color.fromARGB(255, 250, 117, 117),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
