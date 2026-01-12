
import 'package:cashio/features/goals/repository/goal_funds_repository.dart';
import 'package:cashio/features/transactions/model/transaction.dart';

class GetGoalsFunds {
  final GoalFundsRepository repo;
  GetGoalsFunds(this.repo);

  Stream<List<Transaction>> call(String userId) => repo.getGoalFunds(userId);
}
