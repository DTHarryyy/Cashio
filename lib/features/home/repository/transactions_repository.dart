import 'package:cashio/features/home/model/category.dart';
import 'package:cashio/features/home/model/monthly_total.dart';
import 'package:cashio/features/home/model/transactions.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionsRepository {
  final SupabaseClient supabase;
  TransactionsRepository(this.supabase);

  // get all transactiosn of user

  Future<String> addCategory(
    String userId,
    String name,
    String transactionType,
    IconData icon,
    Color color,
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
          'color': color.toARGB32(),
        })
        .select()
        .single();

    return categoryRes['id'];
  }

  // get all transactiosn of user

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

  // get all transactiosn of user

  Stream<List<Transactions>> getTransactions(String userId) {
    return supabase
        .from('transactions')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(10)
        .map((data) => data.map((e) => Transactions.fromMap(e)).toList());
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
      print(response);
      return (response as List)
          .map((e) => MonthlyTotal.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      debugPrint('Error fetching monthly totals: $e');
      debugPrintStack(stackTrace: st);
      return [];
    }
  }

  // get categories of transaction
  Future<List<CategoryModel>> getCategories(String userId) async {
    try {
      final data = await supabase
          .from('categories')
          .select('id, user_id, name, type, icon, color')
          .eq('user_id', userId);

      if (data.isEmpty) return [];

      return data.map<CategoryModel>((e) => CategoryModel.fromJson(e)).toList();
    } catch (e, st) {
      debugPrint('Error fetching categories: $e');
      debugPrintStack(stackTrace: st);
      return [];
    }
  }
}
