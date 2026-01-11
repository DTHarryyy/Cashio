import 'package:cashio/core/provider/supabase_provider.dart';
import 'package:cashio/features/goals/model/fund.dart';
import 'package:cashio/features/goals/repository/goal_funds_repository.dart';
import 'package:cashio/features/goals/usecase/add_goal_fund.dart';
import 'package:cashio/features/goals/usecase/get_goals_funds.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goalFundRepoProvider = Provider(
  (ref) => GoalFundsRepository(ref.watch(supabaseProvider)),
);

// ADD FUND PROVIDER
final addGoalFundProvider = Provider(
  (ref) => AddGoalFund(ref.watch(goalFundRepoProvider)),
);

// READ FUND PROVIDER
final goalFundUseCaseProv = Provider(
  (ref) => GetGoalsFunds(ref.watch(goalFundRepoProvider)),
);
final getGoalFundsProvider = StreamProvider.family<List<Fund>, String>((
  ref,
  userId,
) {
  final useCase = ref.read(goalFundUseCaseProv);
  return useCase(userId);
});
