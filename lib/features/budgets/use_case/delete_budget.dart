import 'package:cashio/features/budgets/repository/budgets_repository.dart';

class DeleteBudget {
  final BudgetsRepository repository;
  DeleteBudget(this.repository);
  Future<void> call(String budgetId) => repository.deleteBudget(budgetId);
}
