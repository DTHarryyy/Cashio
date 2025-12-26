import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:cashio/features/home/model/transactions.dart';
import 'package:cashio/features/home/provider/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AllTransactions extends ConsumerStatefulWidget {
  const AllTransactions({super.key});

  @override
  ConsumerState<AllTransactions> createState() => _AllTransactionsState();
}

class _AllTransactionsState extends ConsumerState<AllTransactions> {
  List filter = ['All', 'Income', 'Expenses'];
  int? selectedvalue = 0;
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(profileProvider);
    return currentUser.when(
      error: (e, _) => Scaffold(body: Text('Youre not loggedin')),
      loading: () => CustomLoading(),
      data: (user) {
        final transactionsAsync = ref.watch(
          getAllTransactionsProvider(user.userId),
        );
        // TODO: chaneg error message and trhrow to error page
        return transactionsAsync.when(
          error: (e, _) => Scaffold(body: Text('There must be an error')),
          loading: () => CustomLoading(),
          data: (transactions) {
            final String selectedFilter = filter[selectedvalue!];

            final filteredTransaction = selectedFilter == 'All'
                ? transactions
                : transactions.where((t) {
                    final type = t.categoryType.toLowerCase();
                    final filterType = selectedFilter.toLowerCase();
                    return type == filterType;
                  }).toList();
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  'Transaction',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                child: Column(
                  spacing: 10,
                  children: [
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
  }
}

class FilteredTransactionContent extends StatelessWidget {
  final List<Transactions> filteredTransaction;
  const FilteredTransactionContent({
    super.key,
    required this.filteredTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 5),
        itemCount: filteredTransaction.length,
        itemBuilder: (context, index) {
          final transaction = filteredTransaction[index];
          final amount = transaction.amount;
          final name = transaction.name;
          final categoryColor = transaction.categoryColor;
          final categoryIcon = transaction.categoryIcon;
          final categoryName = transaction.categoryName;
          final categoryType = transaction.categoryType;

          final formatter = DateFormat('MMM dd yyyy');
          final date = formatter.format(transaction.transactionDate);
          final bool isIncome = categoryType == 'income';

          return Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            child: ListTile(
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
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    isIncome ? '+₱$amount' : '-₱$amount',
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
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
      ),
    );
  }
}
