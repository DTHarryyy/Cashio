import 'package:cashio/features/goals/model/goal.dart';
import 'package:cashio/features/goals/repository/goal_repository.dart';

class AddGoal {
  final GoalRepository repo;
  AddGoal(this.repo);
  Future<void> call(Goal goal) => repo.addGoal(goal);
}
