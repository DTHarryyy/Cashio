class Transactions {
  final String userId;
  final String name;
  final double amount;
  final String categoryId;
  final String? note;
  final DateTime transactionDate;

  Transactions({
    required this.userId,
    required this.name,
    required this.amount,
    required this.categoryId,
    required this.note,
    required this.transactionDate,
  });

  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      userId: map['user_id'] as String,
      categoryId: map['category_id'] as String,
      name: map['transaction_name'] as String,
      amount: (map['amount'] as num).toDouble(),
      note: map['note'] as String?,
      transactionDate: DateTime.parse(map['transaction_date'] as String),
    );
  }
}
