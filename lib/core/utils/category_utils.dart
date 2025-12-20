import 'package:flutter/material.dart';

class CategoryUtils {
  static IconData icon(String category) {
    switch (category) {
      case 'Housing':
        return Icons.home;

      case 'Utilities':
        return Icons.lightbulb_outline;

      case 'Food':
        return Icons.restaurant;

      case 'Transportation':
        return Icons.directions_car;

      case 'Shopping':
        return Icons.shopping_bag;

      case 'Health':
        return Icons.local_hospital;

      case 'Education':
        return Icons.school;

      case 'Entertainment':
        return Icons.movie;

      case 'Travel':
        return Icons.flight;

      case 'Subscriptions':
        return Icons.subscriptions;

      case 'Personal':
        return Icons.person;

      case 'Insurance':
        return Icons.security;

      case 'Gifts & Donations':
        return Icons.card_giftcard;

      case 'Taxes':
        return Icons.receipt_long;

      case 'Miscellaneous':
        return Icons.category;

      default:
        return Icons.help_outline;
    }
  }

  static Color color(String category) {
    switch (category) {
      case 'Housing':
        return Colors.blueGrey;

      case 'Utilities':
        return Colors.amber;

      case 'Food':
        return Colors.orange;

      case 'Transportation':
        return Colors.blue;

      case 'Shopping':
        return Colors.purple;

      case 'Health':
        return Colors.red;

      case 'Education':
        return Colors.indigo;

      case 'Entertainment':
        return Colors.pink;

      case 'Travel':
        return Colors.cyan;

      case 'Subscriptions':
        return Colors.teal;

      case 'Personal':
        return Colors.brown;

      case 'Insurance':
        return Colors.green;

      case 'Gifts & Donations':
        return Colors.deepPurple;

      case 'Taxes':
        return Colors.grey;

      case 'Miscellaneous':
        return Colors.black54;

      default:
        return Colors.grey;
    }
  }
}
