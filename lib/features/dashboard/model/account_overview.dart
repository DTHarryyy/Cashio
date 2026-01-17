class MonthlyOverview {
  final DateTime monthStart;
  final double income;
  final double expense;
  final double balance;

  MonthlyOverview({
    required this.monthStart,
    required this.income,
    required this.expense,
    required this.balance,
  });

  factory MonthlyOverview.fromJson(Map<String, dynamic> json) {
    return MonthlyOverview(
      monthStart: DateTime.parse(json['month_start'] as String),
      income: (json['income'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
    );
  }
}
