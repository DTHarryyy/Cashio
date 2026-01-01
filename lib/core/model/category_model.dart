import 'package:flutter/material.dart';

/// The main category model used for both expenses and budgets.
class CategoryModel {
  final String? id; // Unique ID for each category
  final String name;
  final IconData icon;
  final Color color;
  final String? type;

  const CategoryModel({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.type,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'].toString(), // make sure each category has a unique id
      name: map['category_name'] as String,
      icon: IconData(
        (map['category_icon'] as num).toInt(),
        fontFamily: 'MaterialIcons',
      ),
      color: Color((map['color'] as num).toInt()),
      type: map['type'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
