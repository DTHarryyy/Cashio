import 'package:cashio/features/home/repository/transactions_repository.dart';
import 'package:flutter/material.dart';

class AddCategories {
  final TransactionsRepository repo;

  AddCategories(this.repo);

  Future<String> call(
    String name,
    String transactionType,
    IconData icon,
    Color color,
  ) => repo.addCategory(name, transactionType, icon, color);
}
