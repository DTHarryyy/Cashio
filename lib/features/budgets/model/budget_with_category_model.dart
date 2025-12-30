import 'package:flutter/material.dart';

class BudgetWithCategoryModel {
  final int budgetId;
  final String userId;
  final String title;
  final double budgetAmount;
  final String categoryId;
  final String? notes;
  final String categorName;
  final String categorType;
  final Color categorColor;
  final DateTime createdAt;
  final IconData categorIcon;
  final double remainingBudget;
  final int totalSpent;
  BudgetWithCategoryModel({
    required this.budgetId,
    required this.userId,
    required this.title,
    required this.budgetAmount,
    required this.categoryId,
    required this.remainingBudget,
    this.notes,
    required this.categorName,
    required this.categorType,
    required this.categorColor,
    required this.categorIcon,
    required this.createdAt,
    required this.totalSpent,
  });

  factory BudgetWithCategoryModel.fromMap(Map<String, dynamic> map) {
    return BudgetWithCategoryModel(
      budgetId: map['budget_id'],
      userId: map['user_id'] ?? '',
      title: map['title'] ?? '',
      categoryId: map['category_id'] ?? '',
      budgetAmount: map['budget_amount'] ?? '',
      notes: map['notes'] ?? '',
      categorName: map['category_name'],
      categorType: map['category_type'] ?? '',
      categorIcon: IconData(map['category_icon'], fontFamily: 'MaterialIcons'),
      categorColor: Color(map['category_color']),
      createdAt: DateTime.parse(map['created_at'] as String),
      totalSpent: map['total_spent'] ?? 0.0,
      remainingBudget: map['remaining_budget'] ?? 0.0,
    );
  }
}
