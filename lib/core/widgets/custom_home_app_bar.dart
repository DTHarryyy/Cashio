import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/widgets/avatar.dart';
import 'package:cashio/features/notifications/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomAppBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      title: SizedBox(
        height: 33,
        child: Text(
          'Fundmap',
          style: GoogleFonts.roboto(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      centerTitle: true,
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
