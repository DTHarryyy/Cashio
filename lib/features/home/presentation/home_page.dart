import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return Scaffold(
      body: Center(
        child: profile.when(
          data: (user) => Text(user.username ?? 'a'),
          // TODO: Handle this error correctly
          error: (e, _) => Text(e.toString()),
          loading: () => Text('Loading...'),
        ),
      ),
    );
  }
}
