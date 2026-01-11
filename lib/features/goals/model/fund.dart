class Fund {
  final String? id;
  final String userId;
  final double amount;
  final String goalId;
  final DateTime? createdAt;
  Fund({
    this.id,
    required this.userId,
    required this.amount,
    required this.goalId,
    this.createdAt,
  });

  factory Fund.fromJson(Map<String, dynamic> data) {
    return Fund(
      id: data['id']?.toString(),
      userId: data['user_id'].toString(),
      amount: (data['amount'] as num).toDouble(),
      goalId: data['goal_id'],
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}
