import 'package:cashio/features/home/model/monthly_total.dart';
import 'package:cashio/features/home/model/transaction.dart';
import 'package:cashio/features/home/model/transactions.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionsRepository {
  final SupabaseClient supabase;
  TransactionsRepository(this.supabase);

  // add category

  Future<String> addCategory(
    String name,
    String transactionType,
    IconData icon,
    Color color,
  ) async {
    final categoryRes = await supabase
        .from('categories')
        .insert({
          'category_name': name,
          'category_icon': icon.codePoint,
          'color': color.toARGB32(),
          'type': transactionType,
        })
        .select()
        .single();

    return categoryRes['id'];
  }

  // get all transactiosn of user

  Future<void> addTransaction(Transaction transac) async {
    try {
      await supabase.from('transactions').insert({
        'transaction_name': transac.transactionName,
        'user_id': transac.userId,
        'category_id': transac.cateoryId,
        'budget_id': transac.budgetId,
        'amount': transac.amount,
        'type': transac.type,
        'description': transac.description,
        'transaction_date': transac.transactionDate?.toIso8601String(),
      });
    } on PostgrestException catch (e) {
      throw ('Failed to add expense: ${e.message}');
    }
  }

  // get all transactions of user
  Stream<List<TransactionsDisplay>> getAllTransactions(String userId) {
    return supabase
        .from('transactions_with_category')
        .stream(primaryKey: ['transaction_id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map(
          (data) => data.map((e) => TransactionsDisplay.fromMap(e)).toList(),
        );
  }
  // get 10 recent transactiosn of user

  Future<List<TransactionsDisplay>> getRecentTransactions(String userId) async {
    final data = await supabase
        .from('transactions_with_category')
        .select('*')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(10);

    return data.map((e) => TransactionsDisplay.fromMap(e)).toList();
  }

  // get total expenses / income
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

  // get last 3 months monthly total

  Future<List<MonthlyTotal>> getMonthlyTotal(String userId) async {
    try {
      final response = await supabase.rpc(
        'last_3_months_by_type',
        params: {'p_user_id': userId},
      );

      if (response == null) return [];
      return (response as List)
          .map((e) => MonthlyTotal.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      debugPrint('Error fetching monthly totals: $e');
      debugPrintStack(stackTrace: st);
      return [];
    }
  }
}
