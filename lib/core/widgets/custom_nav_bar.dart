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
          icon: Icon(Icons.dashboard_rounded),
          selectedIcon: Icon(
            Icons.dashboard_rounded,
            color: AppColors.background,
          ),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.swap_vert_rounded),
          selectedIcon: Icon(
            Icons.swap_vert_rounded,
            color: AppColors.background,
          ),
          label: 'Transactions',
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
