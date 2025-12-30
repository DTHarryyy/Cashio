import 'package:flutter/material.dart';

/// The main category model used for both expenses and budgets.
class Category {
  final String id; // unique identifier
  final String name;
  final IconData icon;
  final Color color;

  // Optional fields for budgets
  final double? budgetLimit; // null if not a budget
  final List<String>?
  mappedExpenseIds; // IDs of expense categories mapped to this budget

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.budgetLimit,
    this.mappedExpenseIds,
  });
}

/// ----------------- EXPENSE & BUDGET CATEGORIES -----------------
/// Now we use a single shared list of categories.
class AppCategories {
  // Unique IDs ensure you can reference them in expenses and budgets
  static final List<Category> categories = [
    // Housing & Utilities
    Category(
      id: 'housing',
      name: 'Housing',
      icon: Icons.home,
      color: Color(0xFF6C5CE7),
    ),
    Category(
      id: 'utilities',
      name: 'Utilities',
      icon: Icons.lightbulb,
      color: Color(0xFFFFB142),
    ),
    Category(
      id: 'insurance',
      name: 'Insurance',
      icon: Icons.policy,
      color: Color(0xFFA29BFE),
    ),

    // Food & Essentials
    Category(
      id: 'groceries',
      name: 'Groceries',
      icon: Icons.shopping_cart,
      color: Color(0xFFFF6B6B),
    ),
    Category(
      id: 'food_dining',
      name: 'Dining & Restaurants',
      icon: Icons.fastfood,
      color: Color(0xFFFF6B6B),
    ),

    // Transport & Travel
    Category(
      id: 'transport',
      name: 'Transport',
      icon: Icons.directions_car,
      color: Color(0xFF4BCFFA),
    ),
    Category(
      id: 'travel',
      name: 'Travel',
      icon: Icons.flight,
      color: Color(0xFF00CEC9),
    ),

    // Shopping & Subscriptions
    Category(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: Color(0xFFFD79A8),
    ),
    Category(
      id: 'subscriptions',
      name: 'Subscriptions',
      icon: Icons.subscriptions,
      color: Color(0xFFD980FA),
    ),

    // Health & Fitness
    Category(
      id: 'health',
      name: 'Health & Fitness',
      icon: Icons.health_and_safety,
      color: Color(0xFF00B894),
    ),

    // Education & Personal Growth
    Category(
      id: 'education',
      name: 'Education',
      icon: Icons.school,
      color: Color(0xFF0984E3),
    ),

    // Entertainment & Hobbies
    Category(
      id: 'entertainment',
      name: 'Entertainment',
      icon: Icons.movie,
      color: Color(0xFFFF9F43),
    ),
    Category(
      id: 'hobbies',
      name: 'Hobbies & Leisure',
      icon: Icons.sports_esports,
      color: Color(0xFFFFA500),
    ),

    // Personal & Miscellaneous
    Category(
      id: 'personal_care',
      name: 'Personal Care',
      icon: Icons.person,
      color: Color(0xFFFF7675),
    ),
    Category(
      id: 'gifts',
      name: 'Gifts & Donations',
      icon: Icons.card_giftcard,
      color: Color(0xFFFFD32A),
    ),
    Category(
      id: 'taxes',
      name: 'Taxes',
      icon: Icons.receipt,
      color: Color(0xFF636E72),
    ),
    Category(
      id: 'misc',
      name: 'Miscellaneous',
      icon: Icons.more_horiz,
      color: Color(0xFFB2BEC3),
    ),
  ];
}

/// ----------------- INCOME CATEGORIES -----------------
class IncomeCategories {
  static final List<Category> categories = [
    Category(
      id: 'salary',
      name: 'Salary',
      icon: Icons.attach_money,
      color: Color(0xFF0984E3),
    ),
    Category(
      id: 'business',
      name: 'Business / Freelance',
      icon: Icons.work,
      color: Color(0xFF6C5CE7),
    ),
    Category(
      id: 'investments',
      name: 'Investments',
      icon: Icons.show_chart,
      color: Color(0xFF00B894),
    ),
    Category(
      id: 'gifts_income',
      name: 'Gifts',
      icon: Icons.card_giftcard,
      color: Color(0xFFFFD32A),
    ),
    Category(
      id: 'refunds',
      name: 'Refunds',
      icon: Icons.money_off,
      color: Color(0xFFFF6B6B),
    ),
    Category(
      id: 'other_income',
      name: 'Other',
      icon: Icons.more_horiz,
      color: Color(0xFFB2BEC3),
    ),
  ];
}
