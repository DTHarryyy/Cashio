import 'package:cashio/core/widgets/custom_home_app_bar.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/core/widgets/custom_nav_bar.dart';
import 'package:cashio/core/widgets/custom_speed_dial.dart';
import 'package:cashio/features/budgets/presentation/widget/budget_cards.dart';
import 'package:cashio/features/budgets/provider/budget_provider.dart';
import 'package:cashio/features/home/presentation/widget/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetPage extends ConsumerWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetAsync = ref.watch(budgetPageProvider);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return budgetAsync.when(
      data: (data) {
        return Scaffold(
          key: scaffoldKey,
          appBar: CustomAppBar(scaffoldKey: scaffoldKey),
          drawer: CustomDrawer(),
          bottomNavigationBar: CustomNavBar(),
          floatingActionButton: CustomSpeedDial(),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              spacing: 10,
              children: [
                Expanded(
                  child: BudgetCards(
                    transactions: data.transactions,
                    categoriesData: data.categories,
                    budgets: data.budgets,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (e, _) =>
          Scaffold(body: Center(child: Text('Budget combined error: $e'))),
      loading: () => Scaffold(body: Center(child: CustomLoading())),
    );
  }
}
