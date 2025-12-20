import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/utils/category_utils.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:cashio/features/home/provider/expenses_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ExpensesWidget extends ConsumerWidget {
  const ExpensesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider).value;
    if (user == null) return Text(' There must be an erorir');

    final expensesAsync = ref.watch(getExpensesProvider(user.userId));

    return expensesAsync.when(
      data: (expenses) {
        if (expenses.isEmpty) {
          return const Text('no expenses yet');
        }
        return ListView.separated(
          reverse: true,
          shrinkWrap: true,
          physics: const ScrollPhysics(),

          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];
            final name = expense.name.toUpperCase();
            final amount = expense.amount.toString();
            final category = expense.category;
            final date = DateFormat(
              'MMM dd yyyy',
            ).format(expense.expensesDate).toString();

            return Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              child: ListTile(
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: CategoryUtils.color(category).withAlpha(40),
                  ),

                  child: Icon(
                    CategoryUtils.icon(category),
                    color: CategoryUtils.color(category),
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text('₱$amount', style: GoogleFonts.outfit()),
                  ],
                ),
                subtitle: Row(children: [Text(date)]),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 5),
        );
      },
      error: (e, _) => Text('There must be an error'),
      loading: () => CircularProgressIndicator(),
    );
  }
}
