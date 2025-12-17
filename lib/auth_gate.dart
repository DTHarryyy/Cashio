import 'package:cashio/features/auth/presentation/sign_in_page.dart';
import 'package:cashio/features/auth/provider/auth_state_provider.dart';
import 'package:cashio/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (user) {
        if (user.session == null) {
          return SignInPage();
        } else {
          return HomePage();
        }
      },
      error: (e, stck) => Text('There must be an erro in logging in '),
      loading: () => CircularProgressIndicator(),
    );
  }
}
