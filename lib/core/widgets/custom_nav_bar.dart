import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/provider/page_index_provider.dart';
import 'package:cashio/core/widgets/add_quick_actions_sheet.dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomNavBar extends ConsumerWidget {
  const CustomNavBar({super.key});

  void _onAddPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddQuickActionsSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(pageValueProvider);

    int navIndexFromPage(int page) => page >= 2 ? page + 1 : page;
    int pageFromNavIndex(int navIndex) =>
        navIndex > 2 ? navIndex - 1 : navIndex;

    final navIndex = navIndexFromPage(pageIndex);

    // Safe area handled INSIDE
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    const iconSize = 26.0; // keeps all destinations aligned consistently

    return Material(
      color: Colors.transparent,
      child: Container(
        color: AppColors
            .surface, // paints under system inset (prevents black strip)
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Keep default NavigationBar sizing; only add bottom inset padding
            NavigationBar(
              elevation: 0,
              backgroundColor: AppColors.surface,
              indicatorColor: AppColors.primary,
              selectedIndex: navIndex,
              onDestinationSelected: (value) {
                if (value == 2) {
                  _onAddPressed(context);
                  return;
                }
                ref
                    .read(pageValueProvider.notifier)
                    .changePage(pageFromNavIndex(value));
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_rounded, size: iconSize),
                  selectedIcon: Icon(
                    Icons.dashboard_rounded,
                    size: iconSize,
                    color: AppColors.background,
                  ),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.swap_vert_rounded, size: iconSize),
                  selectedIcon: Icon(
                    Icons.swap_vert_rounded,
                    size: iconSize,
                    color: AppColors.background,
                  ),
                  label: 'Transactions',
                ),

                // Dummy center slot (keeps spacing)
                NavigationDestination(icon: SizedBox.shrink(), label: ''),

                NavigationDestination(
                  icon: Icon(Icons.pie_chart_rounded, size: iconSize),
                  selectedIcon: Icon(
                    Icons.pie_chart_rounded,
                    size: iconSize,
                    color: AppColors.background,
                  ),
                  label: 'Budget',
                ),
                NavigationDestination(
                  icon: Icon(Icons.track_changes, size: iconSize),
                  selectedIcon: Icon(
                    Icons.track_changes,
                    size: iconSize,
                    color: AppColors.background,
                  ),
                  label: 'Goals',
                ),
              ],
            ),

            // Lower, “normal-feel” floating button (not too high)
            Positioned(
              bottom: bottomInset + 12,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _onAddPressed(context),
                  customBorder: const CircleBorder(),
                  child: Ink(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: AppColors.background,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
