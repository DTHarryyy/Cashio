import 'package:cashio/app_router.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/features/auth/model/app_user.dart';
import 'package:cashio/features/auth/presentation/sign_in_page.dart';
import 'package:cashio/features/auth/provider/auth_state_provider.dart';
import 'package:cashio/features/auth/provider/current_user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 👇 react to auth changes safely
    ref.listen(authStateProvider, (previous, next) {
      next.whenData((user) {
        if (user.session == null) {
          ref.read(currentUserProfileProvider.notifier).state = null;
        } else {
          ref.read(currentUserProfileProvider.notifier).state = AppUser(
            userId: user.session!.user.id,
            email: user.session!.user.email!,
            username: user.session!.user.userMetadata?['username'] ?? '',
          );
        }
      });
    });

    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user.session == null) {
          return const SignInPage();
        }
        return const AppRouter();
      },
      error: (e, stck) =>
          const Scaffold(body: Center(child: Text('Auth error'))),
      loading: () => const Scaffold(body: Center(child: CustomLoading())),
    );
  }
}
