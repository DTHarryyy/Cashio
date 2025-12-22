import 'package:cashio/features/home/model/transactions.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionsRepository {
  final SupabaseClient supabase;
  TransactionsRepository(this.supabase);

  Future<String> addCategory(
    String userId,
    String name,
    String transactionType,
    IconData icon,
  ) async {
    final existing = await supabase
        .from('categories')
        .select()
        .eq('user_id', userId)
        .eq('name', name)
        .eq('type', transactionType)
        .maybeSingle();

    if (existing != null) {
      return existing['id'];
    }

    final categoryRes = await supabase
        .from('categories')
        .insert({
          'user_id': userId,
          'name': name,
          'type': transactionType,
          'icon': icon.codePoint,
        })
        .select()
        .single();

    return categoryRes['id'];
  }

  Future<void> addTransaction({
    required String transactionName,
    required String userId,
    required double amount,
    required String categoryId,
    required String note,
    required DateTime? transactionDate,
  }) async {
    try {
      await supabase.from('transactions').insert({
        'transaction_name': transactionName,
        'user_id': userId,
        'category_id': categoryId,
        'amount': amount,
        'note': note,
        'transaction_date': transactionDate?.toIso8601String(),
      });
    } on PostgrestException catch (e) {
      throw ('Failed to add expense: ${e.message}');
    }
  }

  Stream<List<Transactions>> getTransactions(String userId) {
    return supabase
        .from('transactions')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(10)
        .map((data) => data.map((e) => Transactions.fromMap(e)).toList());
  }

  Future<double> getTotalByType(String userId, String categoryType) async {
    try {
      final response = await supabase.rpc(
        'total_by_type',
        params: {'p_user_id': userId, 'p_category_type': categoryType},
      );

      return (response as num).toDouble();
    } catch (e) {
      return 0;
    }
  }
}
