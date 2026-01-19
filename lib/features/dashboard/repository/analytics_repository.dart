import 'package:cashio/features/dashboard/model/account_overview.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalyticsRepository {
  final SupabaseClient supabase;
  AnalyticsRepository(this.supabase);

    
  Future<List<MonthlyOverview>> getMonthlyOverview(String userId) async {
    try {
      final response = await supabase.rpc(
        'get_user_monthly_overview_last_12_months',
        params: {'p_user_id': userId},
      );
      if (response == null) return [];
      return (response as List)
          .map((json) => MonthlyOverview.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      debugPrint('Error fetching account overview: $e');
      debugPrintStack(stackTrace: st);
      return [];
    }
  }
}
