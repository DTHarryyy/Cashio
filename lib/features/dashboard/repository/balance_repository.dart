import 'package:cashio/features/dashboard/model/balance.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BalaceRepository {
  final SupabaseClient supabase;
  BalaceRepository(this.supabase);

  Stream<List<Balance>> getBalance(String userId) {
    return supabase
        .from('balance')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) => data.map((e) => Balance.fromJson(e)).toList());
  }
}
