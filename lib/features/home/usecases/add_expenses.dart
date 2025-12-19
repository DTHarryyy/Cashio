import 'package:cashio/features/home/repository/expenses_repository.dart';

class AddExpenses {
  final ExpensesRepository repo;

  AddExpenses(this.repo);

  Future<void> call({
    required String expensesName,
    required String userId,
    required double amount,
    required String category,
    required DateTime? expensesDate,
  }) => repo.addExpenses(
    expensesName: expensesName,
    userId: userId,
    amount: amount,
    category: category,
    expensesDate: expensesDate,
  );
}
