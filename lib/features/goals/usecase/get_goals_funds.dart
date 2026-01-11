import 'package:cashio/features/goals/model/fund.dart';
import 'package:cashio/features/goals/repository/goal_funds_repository.dart';

class GetGoalsFunds {
  final GoalFundsRepository repo;
  GetGoalsFunds(this.repo);

  Stream<List<Fund>> call(String userId) => repo.getGoalFunds(userId);
}
