import 'package:cashio/features/budgets/model/budget.dart';
import 'package:cashio/features/budgets/repository/budgets_repository.dart';

class UpdateBudget {
  final BudgetsRepository repository;
  UpdateBudget(this.repository);
  Future<void> call(Budget budget) => repository.updateBudget(budget);
}
