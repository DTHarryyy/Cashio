import 'package:cashio/core/provider/category_provider.dart';
import 'package:cashio/core/widgets/custom_home_app_bar.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/core/widgets/custom_nav_bar.dart';
import 'package:cashio/core/widgets/custom_speed_dial.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:cashio/features/budgets/presentation/widget/budget_cards.dart';
import 'package:cashio/features/budgets/provider/budget_provider.dart';
import 'package:cashio/features/home/provider/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetPage extends ConsumerWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(profileProvider);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return userAsync.when(
      error: (e, _) => Scaffold(body: Center(child: Text('budgets error: $e'))),
      loading: () => Scaffold(body: Center(child: CustomLoading())),
      data: (user) {
        final budgetsAsync = ref.watch(getBudgetprovider(user!.userId));

        // budget
        return budgetsAsync.when(
          error: (e, _) =>
              Scaffold(body: Center(child: Text('budgets error: $e'))),
          loading: () =>
              Scaffold(body: Center(child: CircularProgressIndicator())),
          data: (budgets) {
            final categoryAsync = ref.watch(getCategoriesProvider);

            // category
            return categoryAsync.when(
              error: (e, _) =>
                  Scaffold(body: Center(child: Text('Category error : $e'))),
              loading: () =>
                  Scaffold(body: Center(child: CircularProgressIndicator())),
              data: (categoryData) {
                final transactions = ref.watch(
                  getAllTransactionsProvider(user.userId),
                );

                return transactions.when(
                  error: (e, _) => Scaffold(
                    body: Center(child: Text('Transaction error : $e')),
                  ),
                  loading: () => Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                  data: (transaction) {
                    return Scaffold(
                      key: scaffoldKey,
                      appBar: CustomAppBar(scaffoldKey: scaffoldKey),
                      bottomNavigationBar: CustomNavBar(),
                      floatingActionButton: CustomSpeedDial(),
                      body: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        child: Column(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: BudgetCards(
                                transactions: transaction,
                                categoriesData: categoryData,
                                budgets: budgets,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
