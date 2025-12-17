import 'package:cashio/core/provider/supabase_provider.dart';
import 'package:cashio/features/auth/model/app_user.dart';
import 'package:cashio/features/auth/provider/auth_state_provider.dart';
import 'package:cashio/features/auth/repository/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(ref.read(supabaseProvider)),
);

final profileProvider = FutureProvider<AppUser>((ref) async {
  final authState = await ref.watch(authStateProvider.future);
  final session = authState.session;
  if (session == null) throw Exception('Not logged in');
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getMyProfile(session.user.id);
});
