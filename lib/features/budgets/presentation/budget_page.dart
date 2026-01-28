import 'package:cashio/core/widgets/c_filter_clip.dart';
import 'package:cashio/core/widgets/custom_home_app_bar.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/core/widgets/custom_nav_bar.dart';
import 'package:cashio/features/budgets/model/budget.dart';
import 'package:cashio/features/budgets/presentation/widget/budget_cards.dart';
import 'package:cashio/features/budgets/provider/budget_provider.dart';
import 'package:cashio/core/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetPage extends ConsumerStatefulWidget {
  const BudgetPage({super.key});

  @override
  ConsumerState<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends ConsumerState<BudgetPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List filter = ['All', 'Active', 'Exceeded'];
  int selectedValue = 0;
  List<Budget> filteredBudget = [];
  void filterBudget(List<Budget> budget) {
    filteredBudget = filter[selectedValue] == 'All'
        ? budget
        : budget
              .where(
                (b) =>
                    b.status == filter[selectedValue].toString().toLowerCase(),
              )
              .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final budgetAsync = ref.watch(budgetPageProvider);
    return budgetAsync.when(
      data: (data) {
        filterBudget(data.budgets);
        return Scaffold(
          key: scaffoldKey,
          appBar: CustomAppBar(scaffoldKey: scaffoldKey),
          drawer: CustomDrawer(),
          bottomNavigationBar: CustomNavBar(),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              spacing: 10,
              children: [
                CFilterClip(
                  filter: filter,
                  selectedvalue: selectedValue,
                  onChange: (value) => setState(() => selectedValue = value),
                ),
                Expanded(
                  child: BudgetCards(
                    transactions: data.transactions,
                    categoriesData: data.categories,
                    budgets: filteredBudget,
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
