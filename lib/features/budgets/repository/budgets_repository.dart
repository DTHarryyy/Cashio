import 'package:cashio/features/budgets/model/budget_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BudgetsRepository {
  final SupabaseClient supabase;
  BudgetsRepository(this.supabase);

  Future<void> addNewBudget(BudgetModel budget) async {
    await supabase.from('budgets').insert({
      'user_id': budget.userId,
      'title': budget.title,
      'category_id': budget.categoryId,
      'amount': budget.amount,
    });
  }
}
