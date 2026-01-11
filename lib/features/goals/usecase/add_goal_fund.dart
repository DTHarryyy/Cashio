import 'package:cashio/features/goals/model/fund.dart';
import 'package:cashio/features/goals/repository/goal_funds_repository.dart';

class AddGoalFund {
  final GoalFundsRepository repo;
  AddGoalFund(this.repo);

  Future<void> call(Fund fund) => repo.addFund(fund);
}
