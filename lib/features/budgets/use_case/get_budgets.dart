import 'package:cashio/features/budgets/model/budget.dart';
import 'package:cashio/features/budgets/repository/budgets_repository.dart';

class GetBudgets {
  final BudgetsRepository repo;
  GetBudgets(this.repo);

  Stream<List<Budget>> call(String userId) => repo.getBudget(userId);
}
