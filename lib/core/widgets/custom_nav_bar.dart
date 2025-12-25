import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/provider/page_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomNavBar extends ConsumerWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(pageValueProvider);
    return NavigationBar(
      elevation: 0,

      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primary,
      selectedIndex: pageIndex,
      onDestinationSelected: (value) =>
          ref.read(pageValueProvider.notifier).changePage(value),

      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home),
          selectedIcon: Icon(Icons.home_rounded, color: AppColors.background),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_rounded),
          selectedIcon: Icon(
            Icons.bar_chart_rounded,
            color: AppColors.background,
          ),
          label: 'Analytics',
        ),
        NavigationDestination(
          icon: Icon(Icons.pie_chart_rounded),
          selectedIcon: Icon(
            Icons.pie_chart_rounded,

            color: AppColors.background,
          ),
          label: 'Budget',
        ),
        NavigationDestination(
          icon: Icon(Icons.savings),
          selectedIcon: Icon(Icons.savings, color: AppColors.background),
          label: 'Savings',
        ),
        NavigationDestination(
          icon: Icon(Icons.track_changes),
          selectedIcon: Icon(
            Icons.pie_chart_rounded,

            color: AppColors.background,
          ),
          label: 'Goals',
        ),
      ],
    );
  }
}
