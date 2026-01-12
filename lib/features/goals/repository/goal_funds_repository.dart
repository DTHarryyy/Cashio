import 'package:cashio/features/goals/model/fund.dart';
import 'package:cashio/features/transactions/model/transaction.dart';
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

  Stream<List<Transaction>> getGoalFunds(String userId) {
    return supabase
        .from('transactions')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map(
          (data) => data
              .where((t) => t['type'] == 'transfer')
              .map((e) => Transaction.fromJson(e))
              .toList(),
        );
  }
}
