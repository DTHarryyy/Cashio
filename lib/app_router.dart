import 'package:cashio/core/widgets/add_category_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cashio/core/provider/page_index_provider.dart';
import 'package:cashio/features/analytics/analytics_page.dart';
import 'package:cashio/features/budgets/presentation/budget_page.dart';
import 'package:cashio/features/goals/goals_page.dart';
import 'package:cashio/features/savings/savings_page.dart';

class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const pages = [
      AddCategoryPage(),
      AnalyticsPage(),
      BudgetPage(),
      SavingsPage(),
      GoalsPage(),
    ];
    final currentPage = ref.watch(pageValueProvider);
    return pages[currentPage];
  }
}
