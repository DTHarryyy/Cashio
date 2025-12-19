import 'package:supabase_flutter/supabase_flutter.dart';

class ExpensesRepository {
  final SupabaseClient supabase;
  ExpensesRepository(this.supabase);

  Future<void> addExpenses({
    required String expensesName,
    required String userId,
    required double amount,
    required String category,
    required DateTime? expensesDate,
  }) async {
    try {
      await supabase.from('expenses').insert({
        'name': expensesName,
        'user_id': userId,
        'amount': amount,
        'category': category,
        'expenses_date': expensesDate?.toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      });
    } on PostgrestException catch (e) {
      throw Exception('Failed to add expense: ${e.message}');
    }
  }
}
