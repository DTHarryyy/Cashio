import 'package:cashio/features/goals/repository/goal_repository.dart';

class UpdateStatus {
  final GoalRepository repo;
  UpdateStatus(this.repo);

  Future<void> call(String status, String goalId) =>
      repo.updateStatus(status, goalId);
}
