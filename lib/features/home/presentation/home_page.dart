import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/features/auth/model/app_user.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:cashio/features/home/model/monthly_total.dart';
import 'package:cashio/features/home/presentation/widget/balance_card.dart';
import 'package:cashio/features/home/presentation/widget/custom_drawer.dart';
import 'package:cashio/features/home/presentation/widget/custom_home_app_bar.dart';
import 'package:cashio/features/home/presentation/widget/custom_nav_bar.dart';
import 'package:cashio/features/home/presentation/pages/add_transaction.dart';
import 'package:cashio/features/home/presentation/widget/expenses_widget.dart';
import 'package:cashio/features/home/provider/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(profileProvider);

    return userAsync.when(
      error: (e, error) => const Center(child: Text('There must be an error')),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      data: (user) {
        final totalPerMonthsAsync = ref.watch(
          monthlyTotalProvider(user.userId),
        );

        return totalPerMonthsAsync.when(
          error: (e, _) =>
              Scaffold(body: Center(child: Text('throw to error page'))),
          loading: () =>
              Scaffold(body: Center(child: CircularProgressIndicator())),

          data: (monthlyTotal) {
            final transactionAsync = ref.watch(
              combinedTransactionsProvider(user.userId),
            );
            return transactionAsync.when(
              loading: () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => const Center(
                child: Scaffold(
                  body: Center(child: Text('Error loading transactions')),
                ),
              ),

              data: (data) {
                final income = data['income']!;
                final expense = data['expense']!;
                final totalBalance = income - expense;

                return HomePageContents(
                  monthlyTotal: monthlyTotal,
                  user: user,
                  expense: expense,
                  income: income,
                  totalBalance: totalBalance,
                );
              },
            );
          },
        );
      },
    );
  }
}

class HomePageContents extends ConsumerWidget {
  final AppUser user;
  final double expense;
  final double income;
  final double totalBalance;
  final List<MonthlyTotal> monthlyTotal;
  HomePageContents({
    super.key,
    required this.user,
    required this.expense,
    required this.income,
    required this.totalBalance,
    required this.monthlyTotal,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      backgroundColor: AppColors.background,
      appBar: CustomHomeAppBar(scaffoldKey: _scaffoldKey),
      bottomNavigationBar: CustomNavBar(selectedIndex: 1, ontap: (value) => {}),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionPage()),
          );
        },
        child: const Icon(Icons.add_rounded, color: AppColors.background),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: [
            BalanceCard(
              income: income,
              expenses: expense,
              totalBalance: totalBalance,
              monthlyTotal: monthlyTotal,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RECENT TRANSACTION',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text('see all', style: GoogleFonts.outfit(fontSize: 14)),
              ],
            ),
            const Expanded(child: ExpensesWidget()),
          ],
        ),
      ),
    );
  }
}
