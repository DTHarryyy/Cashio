import 'package:cashio/features/home/repository/transactions_repository.dart';
import 'package:flutter/material.dart';

class AddCategories {
  final TransactionsRepository repo;

  AddCategories(this.repo);

  Future<String> call(
    String userId,
    String name,
    String transactionType,
    IconData icon,
  ) => repo.addCategory(userId, name, transactionType, icon);
}
