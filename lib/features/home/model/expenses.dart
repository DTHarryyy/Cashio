class Expenses {
  final String userId;
  final String name;
  final double amount;
  final String category;
  final DateTime expensesDate;

  Expenses({
    required this.userId,
    required this.name,
    required this.amount,
    required this.category,
    required this.expensesDate,
  });

  factory Expenses.fromMap(Map<String, dynamic> map) {
    return Expenses(
      userId: map['user_id'] as String,
      name: map['name'] as String,
      amount: (map['amount'] as num) as double,
      category: map['category'] as String,
      expensesDate: DateTime.parse(map['expenses_date'] as String),
    );
  }
}
