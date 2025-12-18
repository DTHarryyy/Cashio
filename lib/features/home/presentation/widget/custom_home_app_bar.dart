import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomHomeAppBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Cashio',
        style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
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
        // TODO: integrate notifications
        IconButton(
          onPressed: () {},
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
