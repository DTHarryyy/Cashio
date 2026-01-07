import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/dialog/custom_dialog.dart';
import 'package:cashio/core/utils/snackbar.dart';
import 'package:cashio/core/widgets/custom_home_app_bar.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/core/widgets/custom_nav_bar.dart';
import 'package:cashio/core/widgets/custom_drawer.dart';
import 'package:cashio/core/widgets/custom_speed_dial.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:cashio/features/goals/model/goal.dart';
import 'package:cashio/features/goals/presentation/pages/goal_form_page.dart';
import 'package:cashio/features/goals/provider/goal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class GoalsPage extends ConsumerWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final userAsync = ref.watch(profileProvider);
    return userAsync.when(
      error: (e, _) => Scaffold(body: Text('User error: $e')),
      loading: () => Scaffold(body: Center(child: CustomLoading())),

      data: (user) {
        final goalsAsync = ref.watch(getGoalProvider(user!.userId));

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: GoalsPageContent(goals: goals),
              ),
            );
          },
        );
      },
    );
  }
}

class GoalsPageContent extends ConsumerWidget {
  final List<Goal> goals;
  const GoalsPageContent({super.key, required this.goals});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormmater = DateFormat('MMM/dd/yyy');

    final currencyFormatter = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 2,
    );
    if (goals.isEmpty) {
      // TODO: display empty state when no data
      return Center(child: Text('No available goals'));
    }
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemCount: goals.length,

      itemBuilder: (context, index) {
        final goal = goals[index];

        final title = goal.title;
        // final notes = goal.notes;
        final targetAmount = currencyFormatter.format(goal.targetAmount);
        final deadline = dateFormmater.format(goal.deadline);
        final priorityLevel = goal.priorityLevel;
        // final status = goal.status;
        final goalId = goal.goalId;

        int daysLeft = goal.deadline.difference(DateTime.now()).inDays;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                spacing: 10,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue.withAlpha(80),
                    ),
                    child: Icon(Icons.flag, color: Colors.blue),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  MenuAnchor(
                    alignmentOffset: Offset(-65, 0),

                    builder:
                        (
                          BuildContext context,
                          MenuController controller,
                          Widget? child,
                        ) {
                          return IconButton(
                            icon: Icon(
                              controller.isOpen
                                  ? Icons.close_rounded
                                  : Icons.more_horiz_rounded,
                              size: 18,
                            ),
                            onPressed: () {
                              controller.isOpen
                                  ? controller.close()
                                  : controller.open();
                            },
                          );
                        },
                    style: MenuStyle(
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 0),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        AppColors.surface,
                      ),
                    ),
                    menuChildren: [
                      MenuItemButton(
                        onPressed: () {},
                        child: Text(
                          'Contribute to goal',
                          style: GoogleFonts.outfit(),
                        ),
                      ),
                      MenuItemButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoalFormPage(
                              goal: Goal(
                                goalId: goal.goalId,
                                title: title,
                                userId: goal.userId,
                                targetAmount: goal.targetAmount,
                                priorityLevel: priorityLevel,
                                notes: goal.notes,
                                deadline: goal.deadline,
                              ),
                            ),
                          ),
                        ),
                        child: Text('Edit goal', style: GoogleFonts.outfit()),
                      ),
                      MenuItemButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => CustomDialog(
                              title: 'Delete goal',
                              btnText: 'Delete',
                              onConfirm: () async {
                                try {
                                  ref.read(deleteGoalProvider).call(goalId!);
                                  AppSnackBar.success(
                                    context,
                                    'Goal deleted successfully',
                                  );
                                  Navigator.pop(context);
                                } catch (e) {
                                  debugPrint('Delete goal error: $e');
                                }
                              },
                            ),
                          );
                        },
                        child: Text('Delete goal', style: GoogleFonts.outfit()),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                height: 1,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      targetAmount,
                      style: GoogleFonts.outfit(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                    decoration: BoxDecoration(
                      color: priorityLevel == 'high'
                          ? const Color.fromARGB(255, 255, 45, 30).withAlpha(60)
                          : AppColors.success.withAlpha(60),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      priorityLevel,
                      style: GoogleFonts.outfit(
                        color: priorityLevel == 'high'
                            ? const Color.fromARGB(255, 255, 45, 30)
                            : AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Out of $targetAmount',
                      style: GoogleFonts.outfit(color: AppColors.textSecondary),
                    ),
                  ),
                  Text(
                    'priority',
                    style: GoogleFonts.outfit(color: AppColors.textSecondary),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Text('Deadline', style: GoogleFonts.outfit()),
                  ),
                  Text('$daysLeft days left', style: GoogleFonts.outfit()),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text(deadline, style: GoogleFonts.outfit())),
                  Text('50%', style: GoogleFonts.outfit()),
                ],
              ),
              SizedBox(height: 5),
              LinearProgressIndicator(
                value: 0.50,
                backgroundColor: AppColors.background,
                minHeight: 10,
                borderRadius: BorderRadius.circular(30),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.button),
              ),
            ],
          ),
        );
      },
    );
  }
}
