import 'package:cashio/core/provider/supabase_provider.dart';
import 'package:cashio/features/budgets/repository/budgets_repository.dart';
import 'package:cashio/features/budgets/use_case/add_budget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetRepoProvider = Provider(
  (ref) => BudgetsRepository(ref.watch(supabaseProvider)),
);
final addNewBudgetProvider = Provider(
  (ref) => AddBudget(ref.read(budgetRepoProvider)),
);
