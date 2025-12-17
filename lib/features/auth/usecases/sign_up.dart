import 'package:cashio/features/auth/repository/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<void> call(String username, String email, String password) =>
      repository.signUp(username: username, email: email, password: password);
}
