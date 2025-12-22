import 'package:cashio/core/provider/supabase_provider.dart';
import 'package:cashio/features/home/model/transactions.dart';
import 'package:cashio/features/home/repository/transactions_repository.dart';
import 'package:cashio/features/home/usecases/add_categories.dart';
import 'package:cashio/features/home/usecases/add_transaction.dart';
import 'package:cashio/features/home/usecases/get_transaction.dart';
import 'package:cashio/features/home/usecases/get_total_expenses.dart';
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

// retrieve transactions provider
final getTransactionsUseCaseProvider = Provider(
  (ref) => GetTransaction(ref.read(transactionsRepoProvider)),
);
final getTransactionsProvider =
    StreamProvider.family<List<Transactions>, String>((ref, userId) {
      final getTransactions = ref.read(getTransactionsUseCaseProvider);
      return getTransactions(userId: userId);
    });

// total transaction provider
final totalTransactionsUseCaseProvider = Provider(
  (ref) => GetTotalExpenses(ref.read(transactionsRepoProvider)),
);
final totalTransactionsProvider =
    FutureProvider.family<double, ({String userId, String categoryType})>((
      ref,
      params,
    ) async {
      final usecase = ref.read(totalTransactionsUseCaseProvider);
      return usecase(userId: params.userId, categoryType: params.categoryType);
    });

final combinedTransactionsProvider =
    FutureProvider.family<Map<String, double>, String>((ref, userId) async {
      final income = await ref.read(
        totalTransactionsProvider((
          userId: userId,
          categoryType: 'income',
        )).future,
      );
      final expense = await ref.read(
        totalTransactionsProvider((
          userId: userId,
          categoryType: 'expense',
        )).future,
      );
      return {'income': income, 'expense': expense};
    });
