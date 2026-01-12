class Transaction {
  final String? id;
  final String? transactionName;
  final String userId;
  final String? categoryId;
  final String? budgetId;
  final double amount;
  final String type;
  final String? description;
  final DateTime? transactionDate;
  final String? goalId;
  Transaction({
    required this.userId,
    required this.amount,
    required this.type,

    this.id,
    this.transactionName,
    this.categoryId,
    this.budgetId,
    this.description,
    this.transactionDate,
    this.goalId,
  });

  factory Transaction.fromJson(Map<String, dynamic> map) {
    return Transaction(
      userId: map['user_id']?.toString() ?? '',
      id: map['id']?.toString(),
      transactionName: map['transaction_name']?.toString(),
      categoryId: map['category_id']?.toString(),
      goalId: map['goal_id']?.toString(),
      budgetId: map['budget_id']?.toString(),
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      type: map['type']?.toString() ?? '',
      description: map['note']?.toString(),
      transactionDate: map['transaction_date'] != null
          ? DateTime.tryParse(map['transaction_date'])
          : null,
    );
  }
}
