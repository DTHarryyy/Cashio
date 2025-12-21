import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/features/home/presentation/widget/bar_graph.dart';
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
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Balance',
                        style: GoogleFonts.outfit(color: AppColors.border),
                      ),
                      Text(
                        '₱199,999.03',
                        style: GoogleFonts.outfit(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textWhite,
                          height: 1,
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_drop_up_rounded,
                                  color: AppColors.success,
                                ),
                                Text(
                                  '₱199,999',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    color: AppColors.border,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: AppColors.error,
                                ),
                                Text(
                                  '₱199,999',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    color: AppColors.border,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Expanded(child: BarGraph()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
            Expanded(child: ExpensesWidget()),
          ],
        ),
      ),
    );
  }
}
