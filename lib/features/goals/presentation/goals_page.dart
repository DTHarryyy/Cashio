import 'package:cashio/core/widgets/custom_home_app_bar.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/core/widgets/custom_nav_bar.dart';
import 'package:cashio/core/widgets/custom_drawer.dart';
import 'package:cashio/core/widgets/custom_speed_dial.dart';
import 'package:cashio/features/auth/provider/current_user_profile.dart';
import 'package:cashio/features/goals/presentation/widgets/goals_cards.dart';
import 'package:cashio/features/goals/provider/goal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalsPage extends ConsumerWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final userId = ref.watch(currentUserProfileProvider)!.userId;

    final goalsAsync = ref.watch(getGoalProvider(userId));


    return goalsAsync.when(
      error: (e, _) => Scaffold(body: Text('Goals error: $e')),
      loading: () => Scaffold(body: Center(child: CustomLoading())),
      data: (goals) {
        return Scaffold(
          key: scaffoldKey,
          appBar: CustomAppBar(scaffoldKey: scaffoldKey),
          drawer: CustomDrawer(),
          bottomNavigationBar: CustomNavBar(),
          floatingActionButton: CustomSpeedDial(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: GoalsCards(goals: goals),
          ),
        );
      },
    );
  }
}
