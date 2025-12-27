import 'package:flutter/material.dart';

// Your model
class CategoryList {
  final String name;
  final IconData icon;
  final Color color;

  CategoryList({required this.name, required this.icon, required this.color});
}

// ----------------- EXPENSE CATEGORIES -----------------
class ExpenseCategories {
  final List<CategoryList> categories = [
    CategoryList(name: 'Housing', icon: Icons.home, color: Color(0xFF6C5CE7)),
    CategoryList(
      name: 'Utilities',
      icon: Icons.lightbulb,
      color: Color(0xFFFFB142),
    ),
    CategoryList(
      name: 'Food & Dining',
      icon: Icons.fastfood,
      color: Color(0xFFFF6B6B),
    ),
    CategoryList(
      name: 'Transport',
      icon: Icons.directions_car,
      color: Color(0xFF4BCFFA),
    ),
    CategoryList(
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: Color(0xFFFD79A8),
    ),
    CategoryList(
      name: 'Health & Fitness',
      icon: Icons.health_and_safety,
      color: Color(0xFF00B894),
    ),
    CategoryList(
      name: 'Education',
      icon: Icons.school,
      color: Color(0xFF0984E3),
    ),
    CategoryList(
      name: 'Entertainment',
      icon: Icons.movie,
      color: Color(0xFFFF9F43),
    ),
    CategoryList(name: 'Travel', icon: Icons.flight, color: Color(0xFF00CEC9)),
    CategoryList(
      name: 'Subscriptions',
      icon: Icons.subscriptions,
      color: Color(0xFFD980FA),
    ),
    CategoryList(
      name: 'Personal Care',
      icon: Icons.person,
      color: Color(0xFFFF7675),
    ),
    CategoryList(
      name: 'Insurance & Security',
      icon: Icons.policy,
      color: Color(0xFFA29BFE),
    ),
    CategoryList(
      name: 'Gifts & Donations',
      icon: Icons.card_giftcard,
      color: Color(0xFFFFD32A),
    ),
    CategoryList(name: 'Taxes', icon: Icons.receipt, color: Color(0xFF636E72)),
    CategoryList(
      name: 'Miscellaneous',
      icon: Icons.more_horiz,
      color: Color(0xFFB2BEC3),
    ),
  ];
}

// ----------------- INCOME CATEGORIES -----------------
class IncomeCategories {
  final List<CategoryList> categories = [
    CategoryList(
      name: 'Salary',
      icon: Icons.attach_money,
      color: Color(0xFF0984E3),
    ),
    CategoryList(
      name: 'Business / Freelance',
      icon: Icons.work,
      color: Color(0xFF6C5CE7),
    ),
    CategoryList(
      name: 'Investments',
      icon: Icons.show_chart,
      color: Color(0xFF00B894),
    ),
    CategoryList(
      name: 'Gifts',
      icon: Icons.card_giftcard,
      color: Color(0xFFFFD32A),
    ),
    CategoryList(
      name: 'Refunds',
      icon: Icons.money_off,
      color: Color(0xFFFF6B6B),
    ),
    CategoryList(
      name: 'Other',
      icon: Icons.more_horiz,
      color: Color(0xFFB2BEC3),
    ),
  ];
}

// ----------------- BUDGET CATEGORIES -----------------
class BudgetCategories {
  final List<CategoryList> categories = [
    CategoryList(
      name: 'Groceries / Food',
      icon: Icons.fastfood,
      color: Color(0xFFFF6B6B),
    ),
    CategoryList(name: 'Housing', icon: Icons.home, color: Color(0xFF6C5CE7)),
    CategoryList(
      name: 'Utilities',
      icon: Icons.lightbulb,
      color: Color(0xFFFFB142),
    ),
    CategoryList(
      name: 'Transportation',
      icon: Icons.directions_car,
      color: Color(0xFF4BCFFA),
    ),
    CategoryList(
      name: 'Entertainment / Hobbies',
      icon: Icons.movie,
      color: Color(0xFFFF9F43),
    ),
    CategoryList(
      name: 'Savings / Investments',
      icon: Icons.savings,
      color: Color(0xFF00B894),
    ),
    CategoryList(name: 'Travel', icon: Icons.flight, color: Color(0xFF00CEC9)),
    CategoryList(
      name: 'Subscriptions',
      icon: Icons.subscriptions,
      color: Color(0xFFD980FA),
    ),
    CategoryList(
      name: 'Personal / Miscellaneous',
      icon: Icons.more_horiz,
      color: Color(0xFFB2BEC3),
    ),
  ];
}
