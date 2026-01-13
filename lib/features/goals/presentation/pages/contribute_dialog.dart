import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/provider/cash_balance_provider.dart';
import 'package:cashio/core/utils/snackbar.dart';
import 'package:cashio/core/utils/validators.dart';
import 'package:cashio/core/widgets/custom_button.dart';
import 'package:cashio/core/widgets/custom_input_field.dart';
import 'package:cashio/features/auth/provider/current_user_profile.dart';
import 'package:cashio/features/goals/provider/goal_provider.dart';
import 'package:cashio/features/transactions/model/transaction.dart';
import 'package:cashio/features/transactions/provider/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ContributeDialog extends ConsumerWidget {
  final String goalId;
  final double currentAmount;
  final double targetAmount;
  const ContributeDialog({
    super.key,
    required this.goalId,
    required this.currentAmount,
    required this.targetAmount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserProfileProvider)!.userId;

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController amountController = TextEditingController();
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(
        'Contribute to goal',
        style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              hint: 'Amount',
              icon: Icons.attach_money_rounded,
              isNumber: true,
              controller: amountController,
              validator: Validators.numbers('Amount'),
            ),
            CustomButton(
              hint: 'Add fund',
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                try {
                  final amount = double.parse(amountController.text.trim());

                  final newFund = Transaction(
                    userId: userId,
                    amount: amount,
                    goalId: goalId,
                    type: 'transfer',
                  );
                  await ref.read(addTransactionsProvider).call(newFund);
                  await ref
                      .read(lessExpenseInBalanceProvider)
                      .call(userId, amount);
                  if ((currentAmount + amount) >= targetAmount) {
                    // TODO: update complete goal status
                    await ref
                        .read(updateGoalStatusProvider)
                        .call('completed', goalId);
                  }
                  if (!context.mounted) return;
                  AppSnackBar.success(context, 'Fund added successfully');
                  Navigator.pop(context);
                } catch (e) {
                  debugPrint('Add Goal fund error: $e');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
