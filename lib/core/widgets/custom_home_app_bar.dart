import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/widgets/avatar.dart';
import 'package:cashio/features/auth/provider/current_user_profile.dart';
import 'package:cashio/features/notifications/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomAppBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProfileProvider);
    return AppBar(
      backgroundColor: AppColors.surface,
      title: SizedBox(
        height: 33,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, ${user?.username.toString() ?? 'Username'}",
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1,
              ),
            ),
            Text(
              'Welcome Back!',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: const Color.fromARGB(255, 153, 154, 156),
              ),
            ),
          ],
        ),
      ),
      titleSpacing: 0,

      leading: Center(
        child: GestureDetector(
          onTap: () {
            scaffoldKey.currentState?.openDrawer();
          },
          child: Avatar(),
        ),
      ),
      actionsPadding: const EdgeInsets.only(right: 10),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationPage()),
            );
          },
          icon: Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
