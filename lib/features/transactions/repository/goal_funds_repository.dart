import 'package:cashio/features/goals/model/fund.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoalFundsRepository {
  final SupabaseClient supabase;
  GoalFundsRepository(this.supabase);

  Future<void> addFund(Fund fund) async {
    await supabase.from('goal_funds').insert({
      'user_id': fund.userId,
      'goal_id': fund.goalId,
      'amount': fund.amount,
    });
  }
}
