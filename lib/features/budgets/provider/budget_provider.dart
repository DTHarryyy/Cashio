import 'package:cashio/core/provider/supabase_provider.dart';
import 'package:cashio/features/budgets/model/budget_with_category_model.dart';
import 'package:cashio/features/budgets/repository/budgets_repository.dart';
import 'package:cashio/features/budgets/use_case/add_budget.dart';
import 'package:cashio/features/budgets/use_case/get_all_budgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetRepoProvider = Provider(
  (ref) => BudgetsRepository(ref.watch(supabaseProvider)),
);
final addNewBudgetProvider = Provider(
  (ref) => AddBudget(ref.read(budgetRepoProvider)),
);

// gett all users budgets
final getAllbudgesUseCaseProvider = Provider(
  (ref) => GetAllBudgets(ref.read(budgetRepoProvider)),
);

final getAllbudgetProvider =
    StreamProvider.family<List<BudgetWithCategoryModel>, String>((ref, userId) {
      final useCase = ref.read(getAllbudgesUseCaseProvider);
      return useCase(userId);
    });
