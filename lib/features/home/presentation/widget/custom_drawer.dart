import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/core/widgets/avatar.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider);
    return Drawer(
      child: SafeArea(
        child: user.when(
          // TODO: change this to a  custom loading animation
          loading: () => CircularProgressIndicator(),
          error: (e, _) => Text('There must be an error'),
          data: (user) {
            return Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
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
                              user.username!,
                              style: GoogleFonts.outfit(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                height: 1,
                              ),
                            ),
                            Text(
                              user.email,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // TODO: integrate sign out function
                      GestureDetector(
                        onTap: () {},
                        child: Icon(Icons.logout, size: 25),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
