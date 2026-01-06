import 'package:cashio/features/goals/model/goal.dart';
import 'package:cashio/features/goals/repository/goal_repository.dart';

class GetGoals {
  final GoalRepository repo;

  GetGoals(this.repo);

  Stream<List<Goal>> call(String userId) => repo.getGoals(userId);
}
