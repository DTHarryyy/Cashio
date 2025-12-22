import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
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
        final transactionAsync = ref.watch(
          combinedTransactionsProvider(user.userId),
        );
        return transactionAsync.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, _) => const Center(
            child: Scaffold(
              body: Center(child: Text('Error loading transactions')),
            ),
          ),

          data: (data) {
            final income = data['income']!;
            final expense = data['expense']!;
            final totalBalance = income - expense;

            return _HomePageContent(
              income: income,
              expense: expense,
              totalBalance: totalBalance,
            );
          },
        );
      },
    );
  }
}

class _HomePageContent extends StatefulWidget {
  final double income;
  final double expense;
  final double totalBalance;

  const _HomePageContent({
    required this.income,
    required this.expense,
    required this.totalBalance,
  });

  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent> {
  int index = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      backgroundColor: AppColors.background,
      appBar: CustomHomeAppBar(scaffoldKey: _scaffoldKey),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: index,
        ontap: (value) => setState(() => index = value),
      ),
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
          children: [
            BalanceCard(
              income: widget.income,
              expenses: widget.expense,
              totalBalance: widget.totalBalance,
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
