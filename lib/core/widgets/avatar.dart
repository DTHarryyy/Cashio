import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Avatar extends ConsumerWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final user = profileAsync.value;
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.border,
      backgroundImage: user?.avatarUrl != null
          ? NetworkImage(user!.avatarUrl!)
          : const AssetImage('assets/images/default_icon.jpg') as ImageProvider,
      child: ClipRRect(borderRadius: BorderRadiusGeometry.circular(100)),
    );
  }
}
