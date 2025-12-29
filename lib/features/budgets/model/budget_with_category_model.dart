import 'package:flutter/material.dart';

class BudgetWithCategoryModel {
  final String userId;
  final String title;
  final String categoryId;
  final double amount;
  final String? notes;
  final String categorName;
  final String categorType;
  final Color categorColor;
  final IconData categorIcon;
  BudgetWithCategoryModel({
    required this.userId,
    required this.title,
    required this.categoryId,
    required this.amount,
    this.notes,
    required this.categorName,
    required this.categorType,
    required this.categorColor,
    required this.categorIcon,
  });

  factory BudgetWithCategoryModel.fromMap(Map<String, dynamic> map) {
    return BudgetWithCategoryModel(
      userId: map['user_id'] ?? '',
      title: map['title'] ?? '',
      categoryId: map['category_id'] ?? '',
      amount: map['amount'] ?? '',
      categorName: map['categor_name'],
      categorType: map['categor_type'] ?? '',
      categorColor: Color(map['categor_color']),
      categorIcon: IconData(map['categor_icon'], fontFamily: 'MaterialIcons'),
    );
  }
}
