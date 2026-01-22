import 'package:cashio/features/dashboard/model/monthly_total.dart';
import 'package:cashio/features/transactions/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionsRepository {
  final SupabaseClient supabase;
  TransactionsRepository(this.supabase);

  // add atransactiosn of user

  Future<void> addTransaction(Transaction transac) async {
    try {
      await supabase.from('transactions').insert({
        'transaction_name': transac.transactionName,
        'user_id': transac.userId,
        'category_id': transac.categoryId,
        'budget_id': transac.budgetId,
        'amount': transac.amount,
        'type': transac.type,
        'goal_id': transac.goalId,
        'description': transac.description,
        'transaction_date': transac.transactionDate?.toIso8601String(),
      });
    } on PostgrestException catch (e) {
      throw ('Failed to add expense: ${e.message}');
    }
  }

  // get all transactions of user
  Stream<List<Transaction>> getAllTransactions(String userId) {
    return supabase
        .from('transactions')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map(
          (data) => data
              .where((t) => t['type'] != 'transfer')
              .map((e) => Transaction.fromJson(e))
              .toList(),
        );
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

  Future<void> updateTransaction(Transaction transac) async {
    try {
      await supabase
          .from('transactions')
          .update({
            'transaction_name': transac.transactionName,
            'user_id': transac.userId,
            'category_id': transac.categoryId,
            'budget_id': transac.budgetId,
            'amount': transac.amount,
            'type': transac.type,
            'description': transac.description,
            'transaction_date': transac.transactionDate?.toIso8601String(),
          })
          .eq('id', transac.id!);
    } on PostgrestException catch (e) {
      throw ('Failed to add transaction: $e');
    }
  }

  // DELETE THIS TRANSACTION
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await supabase.from('transactions').delete().eq('id', transactionId);
    } on PostgrestException catch (e) {
      throw ('Failed to delete transaction: ${e.message}');
    }
  }
}
