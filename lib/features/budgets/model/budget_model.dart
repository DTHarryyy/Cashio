class BudgetModel {
  final String userId;
  final String title;
  final double amount;
  final String categoryId;
  final String? notes;
  BudgetModel({
    required this.userId,
    required this.title,
    required this.amount,
    required this.categoryId,
    this.notes,
  });
}
