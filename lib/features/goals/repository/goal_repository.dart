import 'package:cashio/features/goals/model/goal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoalRepository {
  final SupabaseClient supabase;
  GoalRepository(this.supabase);

  Future<void> addGoal(Goal goal) async {
    await supabase.from('goals').insert({
      'title': goal.title,
      'user_id': goal.userId,
      'priority_level': goal.priorityLevel,
      'deadline': goal.deadline.toIso8601String(),
      'target_amount': goal.targetAmount,
      'notes': goal.notes,
    });
  }

  Future<void> updateGoal(Goal goal) async {
    await supabase
        .from('goals')
        .update({
          'title': goal.title,
          'user_id': goal.userId,
          'priority_level': goal.priorityLevel,
          'deadline': goal.deadline.toIso8601String(),
          'target_amount': goal.targetAmount,
          'notes': goal.notes,
        })
        .eq('id', goal.goalId!);
  }

  Stream<List<Goal>> getGoals(String userId) {
    return supabase
        .from('goals')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map((e) => Goal.fromJson(e)).toList());
  }

  Future<void> deleteGoal(String goalId) async {
    await supabase.from('goals').delete().eq('id', goalId);
  }
}
