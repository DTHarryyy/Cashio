import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/features/auth/provider/current_user_profile.dart';
import 'package:cashio/features/dashboard/model/balance.dart';
import 'package:cashio/features/dashboard/provider/balance_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider);

    if (profile == null) {
      return const _BalanceCardSkeleton();
    }

    final balanceAsync = ref.watch(getBalanceProvider(profile.userId));

    return balanceAsync.when(
      error: (e, _) => _BalanceCardError(message: e.toString()),
      loading: () => const _BalanceCardSkeleton(),
      data: (balance) => _BalanceCardView(balance: balance),
    );
  }
}

class _BalanceCardView extends StatelessWidget {
  final Balance? balance;
  const _BalanceCardView({required this.balance});

  @override
  Widget build(BuildContext context) {
    final totalIncome = balance?.totalIncome ?? 0.0;
    final totalExpenses = balance?.totalExpenses ?? 0.0;
    final totalBalance = totalIncome - totalExpenses;

    final currency = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 2,
    );

    final w = MediaQuery.sizeOf(context).width;

    // Responsive knobs (keeps it from overflowing on small phones)
    final titleSize = w < 360 ? 13.0 : 14.0;
    final amountSize = w < 360 ? 32.0 : 38.0;
    final statValueSize = w < 360 ? 14.0 : 16.0;
    final padding = w < 360 ? 14.0 : 16.0;

    // Show the right-side ring only when there's enough width
    final showRing = w >= 360;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          // Avoid overflows: let height be flexible but bounded
          constraints: const BoxConstraints(minHeight: 180),
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                const Color.fromARGB(255, 139, 64, 238).withAlpha(140),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(55),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Total Balance',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        color: Colors.white.withAlpha(204),
                        fontSize: titleSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const _Pill(
                    icon: Icons.verified_user_outlined,
                    text: 'Summary',
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Big amount - never overflow
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  currency.format(totalBalance),
                  style: GoogleFonts.outfit(
                    fontSize: amountSize,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.6,
                    height: 1.05,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: _StatsColumn(
                      currency: currency,
                      totalIncome: totalIncome,
                      totalExpenses: totalExpenses,
                      statValueSize: statValueSize,
                    ),
                  ),
                  if (showRing) ...[
                    const SizedBox(width: 12),
                    _MiniRing(income: totalIncome, expense: totalExpenses),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatsColumn extends StatelessWidget {
  final NumberFormat currency;
  final double totalIncome;
  final double totalExpenses;
  final double statValueSize;

  const _StatsColumn({
    required this.currency,
    required this.totalIncome,
    required this.totalExpenses,
    required this.statValueSize,
  });

  @override
  Widget build(BuildContext context) {
    // Wrap prevents overflow if screen is tight; it will go to next line gracefully.
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        SizedBox(
          width:
              220, // a "preferred" width; Wrap will move it if not enough space
          child: _StatTile(
            label: 'Income',
            value: currency.format(totalIncome),
            icon: Icons.arrow_upward_rounded,
            iconBg: AppColors.success.withAlpha(56),
            iconColor: AppColors.success,
            valueFontSize: statValueSize,
          ),
        ),
        SizedBox(
          width: 220,
          child: _StatTile(
            label: 'Expense',
            value: currency.format(totalExpenses),
            icon: Icons.arrow_downward_rounded,
            iconBg: AppColors.error.withAlpha(56),
            iconColor: AppColors.error,
            valueFontSize: statValueSize,
          ),
        ),
      ],
    );
  }
}

class _MiniRing extends StatelessWidget {
  final double income;
  final double expense;
  const _MiniRing({required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    final total = income + expense;
    final ratio = total == 0 ? 0.0 : (income / total).clamp(0.0, 1.0);

    return Container(
      width: 78,
      height: 78,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(26),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(31)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: ratio,
                strokeWidth: 8,
                backgroundColor: Colors.white.withAlpha(31),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withAlpha(230),
                ),
              ),
              Text(
                '${(ratio * 100).round()}%',
                style: GoogleFonts.outfit(
                  color: Colors.white.withAlpha(235),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'Income ratio',
            style: GoogleFonts.outfit(
              color: Colors.white.withAlpha(235),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final double valueFontSize;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.valueFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(31)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: Colors.white.withAlpha(180),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: Colors.white.withAlpha(235),
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Pill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(26),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withAlpha(31)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white.withAlpha(230)),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.outfit(
              color: Colors.white.withAlpha(230),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceCardSkeleton extends StatelessWidget {
  const _BalanceCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final padding = w < 360 ? 14.0 : 16.0;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 180),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withAlpha(200),
            const Color.fromARGB(255, 139, 64, 238).withAlpha(120),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          _SkelLine(width: 120, height: 14),
          SizedBox(height: 14),
          _SkelLine(width: 220, height: 38),
          SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SizedBox(width: 220, child: _SkelBox(height: 56)),
              SizedBox(width: 220, child: _SkelBox(height: 56)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceCardError extends StatelessWidget {
  final String message;
  const _BalanceCardError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 180),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.red.withAlpha(18),
        border: Border.all(color: Colors.red.withAlpha(70)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Couldn’t load balance',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.red.withAlpha(220),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: Colors.red.withAlpha(200),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkelLine extends StatelessWidget {
  final double width;
  final double height;
  const _SkelLine({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(32),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _SkelBox extends StatelessWidget {
  final double height;
  const _SkelBox({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(32),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
