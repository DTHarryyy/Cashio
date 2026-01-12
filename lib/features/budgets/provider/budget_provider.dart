import 'package:cashio/core/model/category_model.dart';
import 'package:cashio/core/provider/category_provider.dart';
import 'package:cashio/core/provider/supabase_provider.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:cashio/features/budgets/model/budget.dart';
import 'package:cashio/features/budgets/repository/budgets_repository.dart';
import 'package:cashio/features/budgets/use_case/add_budget.dart';
import 'package:cashio/features/budgets/use_case/delete_budget.dart';
import 'package:cashio/features/budgets/use_case/get_budgets.dart';
import 'package:cashio/features/budgets/use_case/update_budget.dart';
import 'package:cashio/features/transactions/model/transaction.dart';
import 'package:cashio/features/transactions/provider/transactions_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// budget repository provider

final budgetRepoProvider = Provider(
  (ref) => BudgetsRepository(ref.watch(supabaseProvider)),
);

// add budget repository provider

final addNewBudgetProvider = Provider(
  (ref) => AddBudget(ref.read(budgetRepoProvider)),
);

// get budgets provider
final getBudgetUseCaseProvider = Provider(
  (ref) => GetBudgets(ref.read(budgetRepoProvider)),
);
final getBudgetprovider = StreamProvider.family<List<Budget>, String>((
  ref,
  userId,
) {
  final useCase = ref.read(getBudgetUseCaseProvider);
  return useCase(userId);
});

final budgetPageProvider =
    Provider.autoDispose<
      AsyncValue<
        ({
          List<Budget> budgets,
          List<CategoryModel> categories,
          List<Transaction> transactions,
        })
      >
    >((ref) {
      final userAsync = ref.watch(profileProvider);

      return userAsync.when(
        loading: () => const AsyncLoading(),
        error: (e, st) => AsyncError(e, st),
        data: (user) {
          final budgets = ref.watch(getBudgetprovider(user!.userId));
          final categories = ref.watch(getCategoriesProvider);
          final transactions = ref.watch(
            getAllTransactionsProvider(user.userId),
          );

          if (budgets.isLoading ||
              categories.isLoading ||
              transactions.isLoading) {
            return const AsyncLoading();
          }
          if (budgets.hasError) {
            return AsyncError(budgets.error!, budgets.stackTrace!);
          }
          if (categories.hasError) {
            return AsyncError(categories.error!, categories.stackTrace!);
          }
          if (transactions.hasError) {
            return AsyncError(transactions.error!, transactions.stackTrace!);
          }

          return AsyncData((
            budgets: budgets.value!,
            categories: categories.value!,
            transactions: transactions.value!,
          ));
        },
      );
    });

// update budget repository provider
final updateBudgetProvider = Provider(
  (ref) => UpdateBudget(ref.read(budgetRepoProvider)),
);

// delete budget repository provider
final deleteBudgetProvider = Provider(
  (ref) => DeleteBudget(ref.read(budgetRepoProvider)),
);
