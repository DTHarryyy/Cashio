import 'package:cashio/core/provider/supabase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authStateProvider = StreamProvider<AuthState>((ref) {
  final supabase = ref.watch(supabaseProvider);

  return supabase.auth.onAuthStateChange;
});

final currentUserProvider = Provider<AsyncValue<User?>>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (state) => AsyncData(state.session?.user),
    error: (e, stck) => AsyncError(e, stck),
    loading: () => AsyncLoading(),
  );
});
