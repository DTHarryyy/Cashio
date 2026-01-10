import 'package:cashio/core/provider/supabase_provider.dart';
import 'package:cashio/features/transactions/repository/goal_funds_repository.dart';
import 'package:cashio/features/transactions/usecases/adding%20data/add_goal_fund.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goalFundRepoProvider = Provider(
  (ref) => GoalFundsRepository(ref.watch(supabaseProvider)),
);

final addGoalFundProvider = Provider(
  (ref) => AddGoalFund(ref.watch(goalFundRepoProvider)),
);
