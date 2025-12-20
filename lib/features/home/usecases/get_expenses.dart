import 'package:cashio/features/home/model/expenses.dart';
import 'package:cashio/features/home/repository/expenses_repository.dart';

class GetExpenses {
  final ExpensesRepository repo;

  GetExpenses(this.repo);

  Stream<List<Expenses>> call({required String userId}) =>
      repo.getExpenses(userId);
}
