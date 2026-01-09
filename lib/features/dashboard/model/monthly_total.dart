class MonthlyTotal {
  final DateTime month;
  final String categoryType;
  final double total;

  MonthlyTotal({
    required this.month,
    required this.categoryType,
    required this.total,
  });

  factory MonthlyTotal.fromMap(Map<String, dynamic> map) {
    return MonthlyTotal(
      month: DateTime.parse(
        map['month'] as String,
      ), // <--- parse string to DateTime
      categoryType: map['category_type'] as String,
      total: (map['total'] as num).toDouble(),
    );
  }
}
