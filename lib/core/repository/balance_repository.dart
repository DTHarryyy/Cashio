import 'package:supabase_flutter/supabase_flutter.dart';

class BalanceRepo {
  final SupabaseClient supabase;
  BalanceRepo(this.supabase);

  // update savings cash
  Future<void> addIncomeInBalance({
    required String userId,
    required double amount,
  }) async {
    await supabase.rpc(
      'add_income',
      params: {'p_user_id': userId, 'p_amount': amount},
    );
  }

  Future<void> lessExpensesInBalance({
    required String userId,
    required double amount,
  }) async {
    await supabase.rpc(
      'add_expenses',
      params: {'p_user_id': userId, 'p_amount': amount},
    );
  }
}
