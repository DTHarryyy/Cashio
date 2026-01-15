import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class FinancePieChart extends StatefulWidget {
  final double income;
  final double expense;
  final double savings;
  final double balance;

  const FinancePieChart({
    super.key,
    required this.income,
    required this.expense,
    required this.savings,
    required this.balance,
  });

  @override
  State<FinancePieChart> createState() => _FinancePieChartState();
}

class _FinancePieChartState extends State<FinancePieChart> {
  int touchedIndex = -1;

  final labels = ['Income', 'Expense', 'Savings', 'Balance'];
  final colors = [Colors.green, Colors.red, Colors.blue, Colors.orange];

  late final NumberFormat formatter;

  @override
  void initState() {
    super.initState();
    formatter = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final values = [
      widget.income,
      widget.expense,
      widget.savings,
      widget.balance,
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 90,
          height: 90,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 22,
                  startDegreeOffset: -90,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            response?.touchedSection == null) {
                          touchedIndex = -1;
                        } else {
                          touchedIndex =
                              response!.touchedSection!.touchedSectionIndex;
                        }
                      });
                    },
                  ),
                  sections: List.generate(4, (i) {
                    final isTouched = i == touchedIndex;
                    return PieChartSectionData(
                      value: values[i],
                      color: colors[i],
                      radius: isTouched ? 36 : 30,
                      title: '',
                    );
                  }),
                ),
              ),

              // 🔥 Floating value container
              if (touchedIndex != -1)
                Positioned(
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(85),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          labels[touchedIndex],
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          formatter.format(values[touchedIndex]),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildLegend(),
      ],
    );
  }

  Widget _buildLegend() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendItem("Income", Colors.green),
            const SizedBox(width: 8),
            _legendItem("Expense", Colors.red),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendItem("Savings", Colors.blue),
            const SizedBox(width: 8),
            _legendItem("Balance", Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 10, color: Colors.white)),
      ],
    );
  }
}
