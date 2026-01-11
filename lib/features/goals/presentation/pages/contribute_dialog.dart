import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/utils/snackbar.dart';
import 'package:cashio/core/utils/validators.dart';
import 'package:cashio/core/widgets/custom_button.dart';
import 'package:cashio/core/widgets/custom_input_field.dart';
import 'package:cashio/features/auth/provider/current_user_profile.dart';
import 'package:cashio/features/goals/model/fund.dart';
import 'package:cashio/features/goals/provider/goal_fund_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ContributeDialog extends ConsumerWidget {
  final String goalId;
  const ContributeDialog({super.key, required this.goalId});

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

                  final newFund = Fund(
                    userId: userId,
                    amount: amount,
                    goalId: goalId,
                  );

                  await ref.read(addGoalFundProvider).call(newFund);
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
