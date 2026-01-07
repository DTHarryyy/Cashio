import 'package:cashio/features/goals/model/goal.dart';
import 'package:cashio/features/goals/repository/goal_repository.dart';

class UpdateGoal {
  final GoalRepository repository;
  UpdateGoal(this.repository);
  Future<void> call(Goal goal) => repository.updateGoal(goal);
}
