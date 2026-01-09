import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/features/budgets/presentation/pages/budget_form_page.dart';
import 'package:cashio/features/goals/presentation/pages/goal_form_page.dart';
import 'package:cashio/features/transactions/presentation/transaction_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSpeedDial extends StatelessWidget {
  const CustomSpeedDial({super.key});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      iconTheme: IconThemeData(color: AppColors.textWhite),
      backgroundColor: AppColors.primary,
      buttonSize: Size(58, 58),
      overlayColor: const Color.fromARGB(179, 224, 224, 224),
      curve: Curves.bounceIn,
      spacing: 10,
      children: [
        // add expenses  and income navigating page
        SpeedDialChild(
          elevation: 0,
          shape: CircleBorder(),
          backgroundColor: AppColors.primary.withAlpha(50),
          foregroundColor: AppColors.primary,
          child: Icon(Icons.swap_vert),
          labelWidget: Text(
            'Expenses / Income   ',
            style: GoogleFonts.outfit(),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionFormPage(transaction: null),
              ),
            );
          },
        ),

        // savinsgnavigating page
        SpeedDialChild(
          elevation: 0,
          shape: CircleBorder(),
          backgroundColor: AppColors.primary.withAlpha(50),
          foregroundColor: AppColors.primary,

          child: Icon(Icons.savings),
          labelWidget: Text('Savings   ', style: GoogleFonts.outfit()),

          onTap: () {},
        ),
        SpeedDialChild(
          elevation: 0,
          shape: CircleBorder(),
          backgroundColor: AppColors.primary.withAlpha(50),
          foregroundColor: AppColors.primary,
          child: Icon(Icons.pie_chart_rounded),
          labelWidget: Text('budget   ', style: GoogleFonts.outfit()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddBudgetPage()),
            );
          },
        ),
        SpeedDialChild(
          elevation: 0,
          shape: CircleBorder(),
          backgroundColor: AppColors.primary.withAlpha(50),
          foregroundColor: AppColors.primary,
          child: Icon(Icons.track_changes),
          labelWidget: Text('goals   ', style: GoogleFonts.outfit()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GoalFormPage()),
            );
          },
        ),
      ],
    );
  }
}
