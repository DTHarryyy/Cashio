class Budget {
  final String userId;
  final String name;
  final double totalAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String categoryId;

  Budget({
    required this.userId,
    required this.name,
    required this.totalAmount,
    required this.startDate,
    required this.endDate,
    required this.categoryId,
  });

  factory Budget.fromJson(Map<String, dynamic> data) {
    return Budget(
      userId: data['user_id'],
      name: data['name'],
      totalAmount: data['total-amount'],
      startDate: data['start_date'],
      endDate: data['end_date'],
      categoryId: data['category_id'],
    );
  }
}
