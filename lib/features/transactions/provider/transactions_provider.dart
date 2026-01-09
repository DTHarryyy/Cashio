import 'package:cashio/core/provider/supabase_provider.dart';
import 'package:cashio/features/dashboard/model/monthly_total.dart';
import 'package:cashio/features/dashboard/model/transaction.dart';
import 'package:cashio/features/transactions/repository/transactions_repository.dart';
import 'package:cashio/features/transactions/usecases/adding%20data/add_categories.dart';
import 'package:cashio/features/transactions/usecases/adding%20data/add_transaction.dart';
import 'package:cashio/features/transactions/usecases/delete/delete_transactions.dart';
import 'package:cashio/features/transactions/usecases/getting%20data/get_all_transactions.dart';
import 'package:cashio/features/transactions/usecases/getting%20data/get_last_3months_total.dart';
import 'package:cashio/features/transactions/usecases/getting%20data/get_total_expenses.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// transactions repository provider
final transactionsRepoProvider = Provider(
  (ref) => TransactionsRepository(ref.read(supabaseProvider)),
);

// add categories  provider
final addCategoriesProvider = Provider(
  (ref) => AddCategories(ref.read(transactionsRepoProvider)),
);

// add transactions provider
final addTransactionsProvider = Provider<AddTransaction>(
  (ref) => AddTransaction(ref.read(transactionsRepoProvider)),
);

// retrieve all transactions provider
final getAllTransactionUseCaseProvider = Provider(
  (ref) => GetAllTransactions(ref.watch(transactionsRepoProvider)),
);
final getAllTransactionsProvider =
    StreamProvider.family<List<Transaction>, String>((ref, userId) {
      final getTransaction = ref.read(getAllTransactionUseCaseProvider);
      return getTransaction(userId);
    });

// total transaction provider
final totalTransactionsUseCaseProvider = Provider(
  (ref) => GetTotalExpenses(ref.watch(transactionsRepoProvider)),
);
final totalTransactionsProvider =
    FutureProvider.family<double, ({String userId, String categoryType})>((
      ref,
      params,
    ) async {
      final usecase = ref.watch(totalTransactionsUseCaseProvider);
      return usecase(userId: params.userId, categoryType: params.categoryType);
    });

final combinedTransactionsProvider =
    FutureProvider.family<Map<String, double>, String>((ref, userId) async {
      final income = await ref.watch(
        totalTransactionsProvider((
          userId: userId,
          categoryType: 'income',
        )).future,
      );

      final expense = await ref.watch(
        totalTransactionsProvider((
          userId: userId,
          categoryType: 'expense',
        )).future,
      );

      return {'income': income, 'expense': expense};
    });

// get last 3 months total by income and expenses

final monthlyTotalProvider = FutureProvider.family<List<MonthlyTotal>, String>((
  ref,
  userId,
) {
  final usecase = GetLast3monthsTotal(ref.watch(transactionsRepoProvider));
  return usecase.call(userId);
});

/*
  DELETE TRANSACTION PROVIDER
*/

final deleteTransactionProvider = Provider(
  (ref) => DeleteTransactions(ref.read(transactionsRepoProvider)),
);
