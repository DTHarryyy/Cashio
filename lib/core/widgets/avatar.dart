import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Avatar extends ConsumerWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider);
    // TODO: change this to custom loadding animation
    // TODO:throw the erro to error page
    return user.when(
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text('There must be an error'),
      data: (user) {
        return Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: AppColors.border,
          ),
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(100),
            child: user.avatarUrl == null
                ? Image.asset(
                    'assets/images/default_icon.jpg',
                    fit: BoxFit.cover,
                  )
                : Image.network(user.avatarUrl!, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
