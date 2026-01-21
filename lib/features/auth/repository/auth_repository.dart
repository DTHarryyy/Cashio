import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient supabase;

  AuthRepository(this.supabase);

  Future<User?> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final user = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
    return user.user;
  }

  Future<void> signIn({required String email, required String password}) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
