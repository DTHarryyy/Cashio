import 'package:cashio/features/budgets/model/budget.dart';
import 'package:flutter_riverpod/legacy.dart';

class BudgetStateNotifier extends StateNotifier {
  BudgetStateNotifier() : super([]);

  Future<void> addNewBudget(Budget budget) async {
    state = [...state, budget];
  }
}
