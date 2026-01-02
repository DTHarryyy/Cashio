import 'package:cashio/features/budgets/model/budget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BudgetsRepository {
  final SupabaseClient supabase;
  BudgetsRepository(this.supabase);

  Future<void> addNewBudget(Budget budget) async {
    await supabase.from('budgets').insert({
      'user_id': budget.userId,
      'name': budget.name,
      'total_amount': budget.totalAmount,
      'start_date': budget.startDate.toIso8601String(),
      'end_date': budget.endDate.toIso8601String(),
      'category_uuid': budget.categoryId,
    });
  }

  Stream<List<Budget>> getBudget(String userId) {
    return supabase
        .from('budgets')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map((e) => Budget.fromJson(e)).toList());
  }
}
