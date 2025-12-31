import 'package:cashio/features/budgets/repository/budgets_repository.dart';

class GetAllBudgets {
  final BudgetsRepository repo;
  GetAllBudgets(this.repo);

  // Stream<List<BudgetWithCategoryModel>> call(String userId) =>
  //     repo.getAllBudgets(userId);
}
