import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/widgets/overlay_toast.dart';
import 'package:cashio/features/budgets/presentation/pages/budget_form_page.dart';
import 'package:cashio/features/goals/presentation/pages/goal_form_page.dart';
import 'package:cashio/features/transactions/presentation/transaction_form_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddQuickActionsSheet extends StatelessWidget {
  const AddQuickActionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final safeBottom = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 12 + safeBottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // grab handle
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(12),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Text(
                      'Quick add',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                      splashRadius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                _ActionTile(
                  icon: Icons.swap_vert_rounded,
                  title: 'Expenses / Income',
                  subtitle: 'Record a transaction',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TransactionFormPage(transaction: null),
                      ),
                    );
                  },
                ),
                const _SoftDivider(),

                _ActionTile(
                  icon: Icons.savings_rounded,
                  title: 'Savings',
                  subtitle: 'Add money saved (coming soon)',
                  enabled: false, // you can turn this on later
                  onTap: () {},
                ),
                const _SoftDivider(),

                _ActionTile(
                  icon: Icons.pie_chart_rounded,
                  title: 'Budget',
                  subtitle: 'Create a new budget',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddBudgetPage()),
                    );
                  },
                ),
                const _SoftDivider(),

                _ActionTile(
                  icon: Icons.track_changes,
                  title: 'Goals',
                  subtitle: 'Set a new financial goal',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => GoalFormPage()),
                    );
                  },
                ),

                const SizedBox(height: 14),

                // TODO: add this feature in the future scan receipt
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      OverlayToast.show(
                        context,
                        'Quick add expense feature coming soon',
                      );
                    },
                    icon: const Icon(Icons.document_scanner_rounded),
                    label: Text(
                      'Quick add expense(soon)',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.background,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool enabled;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final fg = enabled ? Colors.black87 : Colors.black38;
    final bg = enabled
        ? AppColors.primary.withAlpha(10)
        : Colors.black.withAlpha(06);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: enabled ? AppColors.primary : fg),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(fontSize: 13, color: fg),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: fg),
          ],
        ),
      ),
    );
  }
}

class _SoftDivider extends StatelessWidget {
  const _SoftDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.black.withAlpha(06),
      ),
    );
  }
}
