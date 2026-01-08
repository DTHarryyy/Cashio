class Budget {
  final String? budgetId;
  final String userId;
  final String name;
  final double totalAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String categoryId;
  final DateTime? createdAt;
  final String? notes;
  Budget({
    this.budgetId,
    required this.userId,
    required this.name,
    required this.totalAmount,
    required this.startDate,
    required this.endDate,
    required this.categoryId,
    this.createdAt,
    this.notes,
  });

  /// From Supabase JSON
  factory Budget.fromJson(Map<String, dynamic> data) {
    return Budget(
      budgetId: data['id'],
      userId: data['user_id'],
      name: data['name'],
      totalAmount: (data['total_amount'] as num).toDouble(),
      startDate: DateTime.parse(data['start_date']),
      endDate: DateTime.parse(data['end_date']),
      categoryId: data['category_uuid'].toString(),
      createdAt: DateTime.parse(data['created_at']),
      notes: data['notes']?.toString(),
    );
  }
}
