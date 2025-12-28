import 'package:cashio/features/budgets/model/budget_model.dart';
import 'package:cashio/features/budgets/repository/budgets_repository.dart';

class AddBudget {
  final BudgetsRepository repo;
  AddBudget(this.repo);

  Future<void> call(BudgetModel budget) => repo.addNewBudget(budget);
}
