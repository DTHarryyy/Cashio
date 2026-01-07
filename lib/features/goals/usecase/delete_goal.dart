import 'package:cashio/features/goals/repository/goal_repository.dart';

class DeleteGoal {
  final GoalRepository repo;

  DeleteGoal(this.repo);

  Future<void> call(String goalId) => repo.deleteGoal(goalId);
}
