import 'package:cashio/features/auth/model/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final SupabaseClient supabase;

  ProfileRepository(this.supabase);

  Future<AppUser?> getMyProfile(String uid) async {
    final data = await supabase
        .from('profiles')
        .select()
        .eq('user_id', uid)
        .maybeSingle();
    if (data == null) return null;

    return AppUser.fromMap(data);
  }
}
