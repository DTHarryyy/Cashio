class Goal {
  final String? goalId;
  final String title;
  final String userId;
  final String priorityLevel;
  final double targetAmount;
  final String? notes;
  final DateTime deadline;
  final String? status;
  final DateTime? dateCreated;
  Goal({
    this.goalId,
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
      goalId: data['id']?.toString(),
      title: data['title'] ?? '',
      userId: data['user_id'] ?? '',
      targetAmount: (data['target_amount'] ?? 0).toDouble(),
      priorityLevel: data['priority_level'] ?? '',
      notes: data['notes']?.toString(),
      status: data['status']?.toString(),
      deadline: data['deadline'] != null
          ? DateTime.tryParse(data['deadline'].toString()) ?? DateTime.now()
          : DateTime.now(),
      dateCreated: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'].toString())
          : null,
    );
  }
}
