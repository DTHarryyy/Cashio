import 'package:cashio/features/goals/model/goal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoalRepository {
  final SupabaseClient supabase;
  GoalRepository(this.supabase);

  Future<void> addGoal(Goal goal) async {
    await supabase.from('goals').insert({
      'title': goal.title,
      'user_id': goal.userId,
      'priority': goal.priorityLevel,
      'deadline': goal.deadline.toIso8601String(),
      'target_amount': goal.targetAmount,
      'notes': goal.notes,
    });
  }
}
