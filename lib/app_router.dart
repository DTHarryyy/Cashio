import 'package:cashio/features/dashboard/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cashio/core/provider/page_index_provider.dart';
import 'package:cashio/features/transactions/presentation/transactions_page.dart';
import 'package:cashio/features/budgets/presentation/budget_page.dart';
import 'package:cashio/features/goals/presentation/goals_page.dart';

class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const pages = [
      HomePage(),
      TransactionsPage(),
      BudgetPage(),
      GoalsPage(),
    ];
    final currentPage = ref.watch(pageValueProvider);
    return pages[currentPage];
  }
}
