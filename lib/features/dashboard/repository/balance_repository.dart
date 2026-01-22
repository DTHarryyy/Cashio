import 'package:cashio/features/dashboard/model/balance.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BalaceRepository {
  final SupabaseClient supabase;
  BalaceRepository(this.supabase);

  Stream<Balance?> getBalance(String userId) {
    return supabase
        .from('balance')
        .stream(primaryKey: ['user_id'])
        .eq('user_id', userId)
        .map((data) => data.isNotEmpty ? Balance.fromJson(data.first) : null);
  }
}
