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
              height: 170,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: GoogleFonts.outfit(
                      color: AppColors.border,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₱199,999.03',
                    style: GoogleFonts.outfit(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: Row(
                      children: [
                        /// Income / Expense
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _StatRow(
                              icon: Icons.arrow_upward,
                              color: AppColors.success,
                              label: 'Income',
                              value: '₱199,999',
                            ),
                            const SizedBox(height: 6),
                            _StatRow(
                              icon: Icons.arrow_downward,
                              color: AppColors.error,
                              label: 'Expense',
                              value: '₱199,999',
                            ),
                          ],
                        ),

                        const SizedBox(width: 12),

                        /// Chart
                        const Expanded(child: BarGraph()),
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

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withAlpha(15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(fontSize: 12, color: AppColors.border),
            ),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
