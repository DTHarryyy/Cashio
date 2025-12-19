import 'package:cashio/features/auth/repository/auth_repository.dart';

class SignIn {
  final AuthRepository repo;

  SignIn(this.repo);

  Future<void> call({required String email, required String password}) =>
      repo.signIn(email: email, password: password);
}
