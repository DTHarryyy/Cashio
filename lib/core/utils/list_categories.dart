import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  final Color color;

  Category({required this.name, required this.icon, required this.color});
}

class ListCategories {
  final List<Category> categories = [
    Category(
      name: 'Housing',
      icon: Icons.home,
      color: Color(0xFF6C5CE7), // vibrant purple
    ),
    Category(
      name: 'Utilities',
      icon: Icons.lightbulb,
      color: Color(0xFFFFB142), // amber
    ),
    Category(
      name: 'Food & Dining',
      icon: Icons.fastfood,
      color: Color(0xFFFF6B6B), // coral red
    ),
    Category(
      name: 'Transport',
      icon: Icons.directions_car,
      color: Color(0xFF4BCFFA), // cyan
    ),
    Category(
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: Color(0xFFFD79A8), // pink
    ),
    Category(
      name: 'Health & Fitness',
      icon: Icons.health_and_safety,
      color: Color(0xFF00B894), // mint green
    ),
    Category(
      name: 'Education',
      icon: Icons.school,
      color: Color(0xFF0984E3), // bright blue
    ),
    Category(
      name: 'Entertainment',
      icon: Icons.movie,
      color: Color(0xFFFF9F43), // orange
    ),
    Category(
      name: 'Travel',
      icon: Icons.flight,
      color: Color(0xFF00CEC9), // teal
    ),
    Category(
      name: 'Subscriptions',
      icon: Icons.subscriptions,
      color: Color(0xFFD980FA), // pastel purple
    ),
    Category(
      name: 'Personal Care',
      icon: Icons.person,
      color: Color(0xFFFF7675), // soft red
    ),
    Category(
      name: 'Insurance & Security',
      icon: Icons.policy,
      color: Color(0xFFA29BFE), // lavender
    ),
    Category(
      name: 'Gifts & Donations',
      icon: Icons.card_giftcard,
      color: Color(0xFFFFD32A), // yellow
    ),
    Category(
      name: 'Taxes',
      icon: Icons.receipt,
      color: Color(0xFF636E72), // grey
    ),
    Category(
      name: 'Miscellaneous',
      icon: Icons.more_horiz,
      color: Color(0xFFB2BEC3), // light grey
    ),
  ];
}
