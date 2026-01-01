class Budget {
  final String? budgetId;
  final String userId;
  final String name;
  final double totalAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String categoryId;

  Budget({
    this.budgetId,
    required this.userId,
    required this.name,
    required this.totalAmount,
    required this.startDate,
    required this.endDate,
    required this.categoryId,
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
    );
  }

  /// To Supabase JSON — must convert DateTime to String!
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'total_amount': totalAmount,
      'start_date': startDate.toIso8601String(), // ✅ convert
      'end_date': endDate.toIso8601String(), // ✅ convert
      'category_uuid': categoryId,
    };
  }
}
