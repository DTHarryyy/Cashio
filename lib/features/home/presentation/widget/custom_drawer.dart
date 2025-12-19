import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/widgets/avatar.dart';
import 'package:cashio/features/auth/provider/auth_provider.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider).value;
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            children: [
              Row(
                spacing: 10,
                children: [
                  GestureDetector(
                    //TODO: add functionality when on tap change avatar
                    onTap: () {},
                    child: Avatar(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          user?.username ?? 'Loading...',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                        Text(
                          user?.email ?? 'Loading...',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => ref.read(signOutProvider).call(),
                    child: Icon(Icons.logout, size: 25),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
