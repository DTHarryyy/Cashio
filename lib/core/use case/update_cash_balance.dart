import 'package:cashio/core/repository/balance_repository.dart';

class AddIncomeInBalance {
  final BalanceRepo repo;
  AddIncomeInBalance(this.repo);

  Future<void> call(String userId, double amount) =>
      repo.addIncomeInBalance(userId: userId, amount: amount);
}

class LessExpenseInBalance {
  final BalanceRepo repo;
  LessExpenseInBalance(this.repo);

  Future<void> call(String userId, double amount) =>
      repo.lessExpensesInBalance(userId: userId, amount: amount);
}
