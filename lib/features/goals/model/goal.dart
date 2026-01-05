class Goal {
  final String? budgetId;
  final String title;
  final String userId;
  final String priorityLevel;
  final double targetAmount;
  final String? notes;
  final DateTime deadline;
  final String? status;
  final DateTime? dateCreated;
  Goal({
    this.budgetId,
    required this.title,
    required this.userId,
    required this.targetAmount,
    this.notes,
    required this.priorityLevel,
    this.status,
    required this.deadline,
    this.dateCreated,
  });

  factory Goal.fromJson(Map<String, dynamic> data) {
    return Goal(
      budgetId: data['id'],
      title: data['title'] as String,
      userId: data['user_id'] as String,
      targetAmount: (data['target_amount'] as num).toDouble(),
      priorityLevel: data['priority_level'] as String,
      notes: data['notes']?.toString(),
      deadline: DateTime.parse(data['deadline'] as String),
      dateCreated: data['created_at'],
    );
  }
}
