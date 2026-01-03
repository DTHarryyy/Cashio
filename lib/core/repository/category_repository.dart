import 'package:cashio/core/model/category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRepository {
  final SupabaseClient supabase;
  CategoryRepository(this.supabase);

  Stream<List<CategoryModel>> getCategory() {
    return supabase
        .from('categories')
        .stream(primaryKey: ['id'])
        .map((data) => data.map((e) => CategoryModel.fromJson(e)).toList());
  }
}
