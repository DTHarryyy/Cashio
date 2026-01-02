class Transaction {
  final String? id;
  final String transactionName;
  final String userId;
  final String cateoryId;
  final String? budgetId;
  final double amount;
  final String type;
  final String? description;
  final DateTime? transactionDate;

  Transaction({
    this.id,
    required this.transactionName,
    required this.userId,
    required this.cateoryId,
    this.budgetId,
    required this.amount,
    required this.type,
    this.description,
    this.transactionDate,
  });

  factory Transaction.fromJson(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      transactionName: map['transaction_name'] as String,
      userId: map['user_id'] as String,
      cateoryId: map['category_id'] as String,
      budgetId: map['budget_id'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: map['type'] as String,
      description: map['note'] as String?,
      transactionDate: DateTime.parse(map['transaction_date'] as String),
    );
  }
}
