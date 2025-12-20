import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/features/home/presentation/widget/custom_drawer.dart';
import 'package:cashio/features/home/presentation/widget/custom_home_app_bar.dart';
import 'package:cashio/features/home/presentation/widget/custom_nav_bar.dart';
import 'package:cashio/features/home/presentation/widget/add_expenses_savings_bottomsheet.dart';
import 'package:cashio/features/home/presentation/widget/expenses_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int index = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      backgroundColor: AppColors.background,

      appBar: CustomHomeAppBar(scaffoldKey: _scaffoldKey),

      bottomNavigationBar: CustomNavBar(
        selectedIndex: index,
        ontap: (value) {
          setState(() => index = value);
        },
      ),

      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: AppColors.primary,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return AddExpensesSavingsBottomsheet();
            },
          );
        },
        child: Icon(Icons.add_rounded, color: AppColors.background),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RECENT EXPENSES',

                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  //TODO: navigate to page where all expenses can be vieqw
                  Text('see all', style: GoogleFonts.outfit(fontSize: 14)),
                ],
              ),
              ExpensesWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
