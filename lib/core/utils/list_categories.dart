import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;

  Category({required this.name, required this.icon});
}

class ListCategories {
  final List<Category> categories = [
    Category(name: 'Housing', icon: Icons.home),
    Category(name: 'Utilities', icon: Icons.lightbulb),
    Category(name: 'Food', icon: Icons.fastfood),
    Category(name: 'Transportation', icon: Icons.directions_car),
    Category(name: 'Shopping', icon: Icons.shopping_bag),
    Category(name: 'Health', icon: Icons.health_and_safety),
    Category(name: 'Education', icon: Icons.school),
    Category(name: 'Entertainment', icon: Icons.movie),
    Category(name: 'Travel', icon: Icons.flight),
    Category(name: 'Subscriptions', icon: Icons.subscriptions),
    Category(name: 'Personal', icon: Icons.person),
    Category(name: 'Insurance', icon: Icons.policy),
    Category(name: 'Gifts & Donations', icon: Icons.card_giftcard),
    Category(name: 'Taxes', icon: Icons.receipt),
    Category(name: 'Miscellaneous', icon: Icons.more_horiz),
  ];
}
