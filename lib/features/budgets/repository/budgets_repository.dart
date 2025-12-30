import 'package:cashio/features/budgets/model/budget_model.dart';
import 'package:cashio/features/budgets/model/budget_with_category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BudgetsRepository {
  final SupabaseClient supabase;
  BudgetsRepository(this.supabase);

  Future<void> addNewBudget(BudgetModel budget) async {
    await supabase.from('budgets').insert({
      'user_id': budget.userId,
      'title': budget.title,
      'category_id': budget.categoryId,
      'budget_limit': budget.amount,
    });
  }

  Stream<List<BudgetWithCategoryModel>> getAllBudgets(String userId) {
    return supabase
        .from('budget_with_categories_display')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map(
          (data) =>
              data.map((e) => BudgetWithCategoryModel.fromMap(e)).toList(),
        );
  }
}
