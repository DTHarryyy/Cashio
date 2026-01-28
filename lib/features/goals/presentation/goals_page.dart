import 'package:cashio/core/widgets/c_filter_clip.dart';
import 'package:cashio/core/widgets/custom_home_app_bar.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/core/widgets/custom_nav_bar.dart';
import 'package:cashio/core/widgets/custom_drawer.dart';
import 'package:cashio/features/auth/provider/current_user_profile.dart';
import 'package:cashio/features/goals/model/goal.dart';
import 'package:cashio/features/goals/presentation/widgets/goals_cards.dart';
import 'package:cashio/features/goals/provider/goal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalsPage extends ConsumerStatefulWidget {
  const GoalsPage({super.key});

  @override
  ConsumerState<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends ConsumerState<GoalsPage> {
  final List filter = ['All', 'Inprogress', 'Completed'];
  int selectedvalue = 0;
  late String userId;

  late List<Goal> updatedGoal = [];
  void updateGoals(List<Goal> goal) {
    final selectedFilter = filter[selectedvalue];
    final filteredGoal = selectedFilter == 'All'
        ? goal
        : goal
              .where((g) => g.status == filter[selectedvalue].toLowerCase())
              .toList();
    setState(() {
      updatedGoal = filteredGoal;
    });
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    userId = ref.watch(currentUserProfileProvider)!.userId;

    final goalsAsync = ref.watch(getGoalProvider(userId));

    return goalsAsync.when(
      error: (e, _) => Scaffold(body: Text('Goals error: $e')),
      loading: () => Scaffold(body: Center(child: CustomLoading())),
      data: (goals) {
        updateGoals(goals);
        return Scaffold(
          key: scaffoldKey,
          appBar: CustomAppBar(scaffoldKey: scaffoldKey),
          drawer: CustomDrawer(),
          bottomNavigationBar: CustomNavBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              spacing: 10,
              children: [
                CFilterClip(
                  filter: filter,
                  selectedvalue: selectedvalue,
                  onChange: (index) => setState(() => selectedvalue = index),
                ),
                Expanded(child: GoalsCards(goals: updatedGoal)),
              ],
            ),
          ),
        );
      },
    );
  }
}
