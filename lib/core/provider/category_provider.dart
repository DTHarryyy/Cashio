import 'package:cashio/core/model/category_model.dart';
import 'package:cashio/core/provider/supabase_provider.dart';
import 'package:cashio/core/repository/category_repository.dart';
import 'package:cashio/core/use%20case/get_category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRepoProvider = Provider(
  (ref) => CategoryRepository(ref.watch(supabaseProvider)),
);

// get categories
final categoryUseCaseProvider = Provider((ref) {
  final repo = ref.read(categoryRepoProvider);
  return GetCategory(repo);
});
final getCategoriesProvider = StreamProvider<List<CategoryModel>>((ref) {
  final useCase = ref.read(categoryUseCaseProvider);
  return useCase();
});
