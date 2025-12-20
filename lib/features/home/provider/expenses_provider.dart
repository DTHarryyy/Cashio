import 'package:cashio/core/provider/supabase_provider.dart';
import 'package:cashio/features/home/model/expenses.dart';
import 'package:cashio/features/home/repository/expenses_repository.dart';
import 'package:cashio/features/home/usecases/add_expenses.dart';
import 'package:cashio/features/home/usecases/get_expenses.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expensesRepoProvider = Provider(
  (ref) => ExpensesRepository(ref.read(supabaseProvider)),
);

final addExpensesProvider = Provider(
  (ref) => AddExpenses(ref.read(expensesRepoProvider)),
);

final getExpensesUseCaseProvider = Provider(
  (ref) => GetExpenses(ref.read(expensesRepoProvider)),
);

final getExpensesProvider = StreamProvider.family<List<Expenses>, String>((
  ref,
  userId,
) {
  final getExpenses = ref.read(getExpensesUseCaseProvider);
  return getExpenses(userId: userId);
});
