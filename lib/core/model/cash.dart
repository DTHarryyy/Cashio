class Cash {
  final String userId;
  final double? cashBalance;
  final double? savingsFundBalance;

  Cash({required this.userId, this.cashBalance, this.savingsFundBalance});

  factory Cash.fromJson(Map<String, dynamic> data) {
    return Cash(
      userId: data['user_id'],
      cashBalance: (data['cash_balance'] as num).toDouble(),
      savingsFundBalance: (data['savings_fund_balance'] as num).toDouble(),
    );
  }
}
