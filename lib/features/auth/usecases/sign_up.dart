import 'package:cashio/features/auth/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<User?> call(String username, String email, String password) =>
      repository.signUp(username: username, email: email, password: password);
}
