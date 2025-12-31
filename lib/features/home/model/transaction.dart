class Transaction {
  final String transactionName;
  final String userId;
  final String cateoryId;
  final String budgetId;
  final double amount;
  final String type;
  final String? description;
  final DateTime? transactionDate;

  Transaction({
    required this.transactionName,
    required this.userId,
    required this.cateoryId,
    required this.budgetId,
    required this.amount,
    required this.type,
    this.description,
    this.transactionDate,
  });
}
