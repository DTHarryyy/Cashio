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
      id: data['id'],
      userId: data['user_id'],
      amount: data['amount'],
      goalId: data['goal_id'],
      createdAt: data['created_at'],
    );
  }
}
