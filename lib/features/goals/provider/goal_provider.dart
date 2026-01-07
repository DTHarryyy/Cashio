import 'package:cashio/core/provider/supabase_provider.dart';
import 'package:cashio/features/goals/model/goal.dart';
import 'package:cashio/features/goals/repository/goal_repository.dart';
import 'package:cashio/features/goals/usecase/add_goal.dart';
import 'package:cashio/features/goals/usecase/delete_goal.dart';
import 'package:cashio/features/goals/usecase/get_goals.dart';
import 'package:cashio/features/goals/usecase/update_goal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// goal repository provider
final goalRepoProvider = Provider(
  (ref) => GoalRepository(ref.read(supabaseProvider)),
);

// adding bnew goal provider
final addGoalProvider = Provider((ref) => AddGoal(ref.read(goalRepoProvider)));

// get users goals
final getGoalUseCaseProv = Provider(
  (ref) => GetGoals(ref.read(goalRepoProvider)),
);
final getGoalProvider = StreamProvider.family<List<Goal>, String>((
  ref,
  userId,
) {
  final useCase = ref.read(getGoalUseCaseProv);
  return useCase(userId);
});

// delete goal use case provider
final deleteGoalProvider = Provider(
  (ref) => DeleteGoal(ref.read(goalRepoProvider)),
);

//final update goal use case provider
final updateGoalProvider = Provider(
  (ref) => UpdateGoal(ref.read(goalRepoProvider)),
);
