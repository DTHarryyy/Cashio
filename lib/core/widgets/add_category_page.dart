import 'package:cashio/core/model/category_model.dart';
import 'package:cashio/core/utils/list_categories.dart';
import 'package:cashio/core/utils/snackbar.dart';
import 'package:cashio/features/home/provider/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCategoryPage extends ConsumerStatefulWidget {
  const AddCategoryPage({super.key});

  @override
  ConsumerState<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends ConsumerState<AddCategoryPage> {
  String _categoryType = 'expense';
  late List<CategoryModel> _currentCategories;
  CategoryModel? _selectedCategory;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.category;

  @override
  void initState() {
    super.initState();
    _currentCategories = AppCategories.categories;
  }

  void _onTypeChanged(String? type) {
    if (type == null) return;
    setState(() {
      _categoryType = type;
      _currentCategories = type == 'expense'
          ? AppCategories.categories
          : IncomeCategories.categories;
      _selectedCategory = null;
      _nameController.clear();
      _idController.clear();
      _selectedColor = Colors.blue;
      _selectedIcon = Icons.category;
    });
  }

  void _onCategorySelected(CategoryModel? category) {
    if (category == null) return;
    setState(() {
      _selectedCategory = category;
      _nameController.text = category.name;
      _selectedColor = category.color;
      _selectedIcon = category.icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    final addCategoryProvider = ref.read(addCategoriesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Category')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Category type
            DropdownButtonFormField<String>(
              initialValue: _categoryType,
              items: [
                'expense',
                'income',
              ].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: _onTypeChanged,
              decoration: const InputDecoration(
                labelText: 'Category Type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Category dropdown
            DropdownButtonFormField<CategoryModel>(
              initialValue: _selectedCategory,
              items: _currentCategories
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Row(
                        children: [
                          Icon(c.icon, color: c.color),
                          const SizedBox(width: 8),
                          Text(c.name),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: _onCategorySelected,
              decoration: const InputDecoration(
                labelText: 'Select Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Name input
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Color preview
            Row(
              children: [
                const Text('Color:'),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Icon preview
            Row(
              children: [
                const Text('Icon:'),
                const SizedBox(width: 8),
                Icon(_selectedIcon, color: _selectedColor),
              ],
            ),
            const SizedBox(height: 32),

            // Submit button
            ElevatedButton(
              onPressed: () async {
                try {
                  await addCategoryProvider.call(
                    _nameController.text,
                    _categoryType,
                    _selectedIcon,
                    _selectedColor,
                  );
                  if (!context.mounted) return;
                  AppSnackBar.success(context, 'added sucessfully');
                } catch (e) {
                  AppSnackBar.error(context, 'Eror: $e');
                }
              },
              child: const Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }
}
