import 'package:cashio/core/constant/app_colors.dart';
import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> ontap;
  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: NavigationBar(
        elevation: 0,

        surfaceTintColor: Colors.transparent,

        backgroundColor: AppColors.background,
        indicatorColor: AppColors.primary,
        selectedIndex: selectedIndex,
        onDestinationSelected: ontap,

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            selectedIcon: Icon(Icons.home, color: AppColors.background),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.home),
            selectedIcon: Icon(Icons.home, color: AppColors.background),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.home),
            selectedIcon: Icon(Icons.home, color: AppColors.background),
            label: 'Home',
          ),
        ],
      ),
    );
  }
}
