import 'package:cashio/features/budgets/model/budget_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class BudgetStateNotifier extends StateNotifier {
  BudgetStateNotifier() : super([]);

  Future<void> addNewBudget(BudgetModel budget) async {
    state = [...state, budget];
  }
}
