import 'package:cashio/core/widgets/custom_home_app_bar.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/core/widgets/custom_nav_bar.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
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
        return Scaffold(
          key: scaffoldKey,
          appBar: CustomAppBar(scaffoldKey: scaffoldKey),
          bottomNavigationBar: CustomNavBar(),
          body: Center(child: Text('Budget page')),
        );
        // final budgetsAsync = ref.watch(getAllbudgetProvider(user.userId));

        // return budgetsAsync.when(
        //   error: (e, _) =>
        //       Scaffold(body: Center(child: Text('budgets error: $e'))),
        //   loading: () =>
        //       Scaffold(body: Center(child: CircularProgressIndicator())),
        //   data: (budgets) {
        //     return Scaffold(
        //       key: scaffoldKey,
        //       appBar: CustomAppBar(scaffoldKey: scaffoldKey),
        //       bottomNavigationBar: CustomNavBar(),
        //       body: Container(
        //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        //         child: Column(
        //           spacing: 10,
        //           children: [BudgetCards(budgets: budgets)],
        //         ),
        //       ),
        //     );
        //   },
        // );
      },
    );
  }
}
