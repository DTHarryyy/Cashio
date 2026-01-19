

class Balance{
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;
  Balance({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
  });

  factory Balance.fromJson(Map<String, dynamic> json){
    return Balance(
      totalBalance: (json['total_balance'] as num).toDouble(),
      totalIncome: (json['total_income'] as num).toDouble(),
      totalExpenses: (json['total_expenses'] as num).toDouble(),
    );
  }
}