import 'package:cashio/core/provider/supabase_provider.dart';
import 'package:cashio/features/dashboard/model/balance.dart';
import 'package:cashio/features/dashboard/repository/balance_repository.dart';
import 'package:cashio/features/dashboard/usecases/get_balance.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final balanceRepoProvider = Provider(
  (ref) => BalaceRepository(ref.read(supabaseProvider)),
);

//read balance
final getBalanceUseCaseProvider = Provider(
  (ref) => GetBalance(ref.watch(balanceRepoProvider)),
);
final getBalanceProvider = StreamProvider.family<List<Balance>, String>((
  ref,
  userId,
) {
  final useCase = ref.read(getBalanceUseCaseProvider);
  return useCase(userId);
});
