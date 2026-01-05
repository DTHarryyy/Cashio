import 'package:cashio/core/provider/supabase_provider.dart';
import 'package:cashio/features/goals/repository/goal_repository.dart';
import 'package:cashio/features/goals/usecase/add_goal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// goal repository provider
final goalRepoProvider = Provider(
  (ref) => GoalRepository(ref.read(supabaseProvider)),
);

// adding bnew goal provider
final addGoalProvider = Provider((ref) => AddGoal(ref.read(goalRepoProvider)));
