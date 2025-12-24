import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String userId;
  final String type;
  final String name;
  final IconData icon;
  final Color color;

  CategoryModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.name,
    required this.icon,
    required this.color,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      type: map['type'] as String,
      name: map['name'] as String,
      icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'),
      color: Color(map['color'] as int),
    );
  }
}
