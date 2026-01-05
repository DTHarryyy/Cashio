import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/widgets/custom_home_app_bar.dart';
import 'package:cashio/core/widgets/custom_nav_bar.dart';
import 'package:cashio/core/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: scaffoldKey),
      drawer: CustomDrawer(),
      bottomNavigationBar: CustomNavBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: GoalsPageContent(),
      ),
    );
  }
}

class GoalsPageContent extends StatelessWidget {
  const GoalsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // key: ValueKey(budget.budgetId),
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
                      'Trip to japan',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_vert_rounded),
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
                      '3122312',
                      style: GoogleFonts.outfit(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        255,
                        45,
                        30,
                      ).withAlpha(60),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'High',
                      style: GoogleFonts.outfit(
                        color: const Color.fromARGB(255, 255, 45, 30),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Out of 50,00',
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
                  Text('-56 days left', style: GoogleFonts.outfit()),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('MM/dd/yyy', style: GoogleFonts.outfit()),
                  ),
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
        ),
      ],
    );
  }
}
