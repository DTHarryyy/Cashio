import 'package:flutter/material.dart';

/// The main category model used for both expenses and budgets.
class CategoryModel {
  final String name;
  final IconData icon;
  final Color color;
  final String? type;

  const CategoryModel({
    required this.name,
    required this.icon,
    required this.color,
    this.type,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['category_name'] as String,
      icon: IconData(map['category_icon'] as int, fontFamily: 'MaterialIcons'),
      color: Color(map['color'] as int),
      type: map['type'] as String,
    );
  }
}
