import 'package:cashio/core/provider/supabase_provider.dart';
import 'package:cashio/features/auth/repository/auth_repository.dart';
import 'package:cashio/features/auth/usecases/sign_in.dart';
import 'package:cashio/features/auth/usecases/sign_out.dart';
import 'package:cashio/features/auth/usecases/sign_up.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(ref.read(supabaseProvider)),
);

final signUpProvider = Provider(
  (ref) => SignUp(ref.read(authRepositoryProvider)),
);

final signInProvider = Provider(
  (ref) => SignIn(ref.read(authRepositoryProvider)),
);
final signOutProvider = Provider(
  (ref) => SignOut(ref.read(authRepositoryProvider)),
);
