import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/dialog/custom_dialog.dart';
import 'package:cashio/core/model/category_model.dart';
import 'package:cashio/core/provider/category_provider.dart';
import 'package:cashio/core/utils/snackbar.dart';
import 'package:cashio/core/widgets/custom_drawer.dart';
import 'package:cashio/core/widgets/custom_home_app_bar.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/core/widgets/custom_nav_bar.dart';
import 'package:cashio/core/widgets/custom_speed_dial.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:cashio/features/dashboard/model/transaction.dart';
import 'package:cashio/features/transactions/presentation/transaction_form_page.dart';
import 'package:cashio/features/transactions/provider/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  List filter = ['All', 'Income', 'Expense'];
  int? selectedvalue = 0;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final currentUser = ref.watch(profileProvider);
    return currentUser.when(
      error: (e, _) => Scaffold(body: Text('Youre not loggedin')),
      loading: () => Scaffold(body: Center(child: CustomLoading())),
      data: (user) {
        final categoryAsync = ref.watch(getCategoriesProvider);

        return categoryAsync.when(
          error: (e, _) =>
              Scaffold(body: Center(child: Text('Category error: $e'))),
          loading: () => Scaffold(body: CustomLoading()),
          data: (categoryData) {
            final transactionsAsync = ref.watch(
              getAllTransactionsProvider(user!.userId),
            );
            // TODO: chaneg error message and trhrow to error page
            return transactionsAsync.when(
              error: (e, _) => Scaffold(
                body: Center(child: Text('There must be an error $e')),
              ),
              loading: () => CustomLoading(),
              data: (transactions) {
                // TODO: display empty widget
                final String selectedFilter = filter[selectedvalue!];

                final filteredTransaction = selectedFilter == 'All'
                    ? transactions
                    : transactions.where((t) {
                        final type = t.type.toLowerCase();
                        final filterType = selectedFilter.toLowerCase();
                        return type == filterType;
                      }).toList();
                return Scaffold(
                  appBar: CustomAppBar(scaffoldKey: scaffoldKey),
                  bottomNavigationBar: const CustomNavBar(),
                  drawer: CustomDrawer(),
                  floatingActionButton: CustomSpeedDial(),
                  body: Container(
                    // decoration: const BoxDecoration(color: AppColors.surface),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 15,
                    ),
                    child: Column(
                      spacing: 10,
                      children: [
                        // filter chips
                        Row(
                          spacing: 5,
                          children: List<Widget>.generate(3, (index) {
                            return ChoiceChip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(35),
                              ),
                              label: Text(
                                filter[index],
                                style: GoogleFonts.outfit(
                                  color: selectedvalue == index
                                      ? AppColors.textWhite
                                      : null,
                                ),
                              ),
                              checkmarkColor: selectedvalue == index
                                  ? AppColors.textWhite
                                  : null,
                              selected: selectedvalue == index,
                              selectedColor: AppColors.primary,

                              onSelected: (bool selected) {
                                setState(() {
                                  selectedvalue = selected ? index : 0;
                                });
                              },
                            );
                          }).toList(),
                        ),
                        FilteredTransactionContent(
                          categoryData: categoryData,
                          filteredTransaction: filteredTransaction,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class FilteredTransactionContent extends ConsumerWidget {
  final List<CategoryModel> categoryData;
  final List<Transaction> filteredTransaction;
  const FilteredTransactionContent({
    super.key,
    required this.categoryData,
    required this.filteredTransaction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 2,
    );
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 5),
        itemCount: filteredTransaction.length,
        itemBuilder: (context, index) {
          final categoryMap = {for (var c in categoryData) c.id: c};
          final transaction = filteredTransaction[index];

          final category = categoryMap[transaction.categoryId];

          final amount = currencyFormatter.format(transaction.amount);
          final name = transaction.transactionName;
          final categoryName = category?.name ?? 'Other';
          final categoryColor =
              category?.color ?? const Color.fromARGB(255, 221, 158, 135);
          final categoryIcon = category?.icon ?? Icons.help;
          final categoryType = transaction.type;

          final formatter = DateFormat('MMM dd yyyy');
          final date = formatter.format(transaction.transactionDate!);
          final bool isIncome = categoryType == 'income';

          return MenuAnchor(
            alignmentOffset: Offset(0, -40),
            style: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.surface),
            ),
            menuChildren: [
              MenuItemButton(
                leadingIcon: const Icon(Icons.edit_rounded),
                child: const Text('Edit transaction'),
                onPressed: () {
                  final transac = Transaction(
                    transactionName: name,
                    userId: transaction.userId,
                    categoryId: transaction.categoryId,
                    amount: transaction.amount,
                    type: transaction.type,
                    id: transaction.id,
                    transactionDate: transaction.transactionDate,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TransactionFormPage(transaction: transac),
                    ),
                  );
                },
              ),
              MenuItemButton(
                leadingIcon: const Icon(Icons.delete_outline),
                child: const Text('Delete'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      title: 'Delete Transaction',
                      btnText: 'Delete',
                      onConfirm: () async {
                        await ref
                            .read(deleteTransactionProvider)
                            .call(transaction.id!);
                        if (!context.mounted) return;
                        AppSnackBar.success(
                          context,
                          'Transaction successfully deleted',
                        );
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ],
            builder: (context, controller, child) {
              return Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                child: ListTile(
                  onLongPress: () {
                    controller.open();
                  },

                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: categoryColor.withAlpha(80),
                    ),

                    child: Icon(categoryIcon),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        isIncome ? '+$amount' : '-$amount',
                        style: GoogleFonts.outfit(
                          color: isIncome ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(date),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor,
                          borderRadius: BorderRadius.circular(25),
                        ),

                        child: Text(
                          categoryName,
                          style: GoogleFonts.outfit(color: AppColors.surface),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
