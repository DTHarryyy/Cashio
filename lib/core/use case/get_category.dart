import 'package:cashio/core/model/category_model.dart';
import 'package:cashio/core/repository/category_repository.dart';

class GetCategory {
  final CategoryRepository repo;
  GetCategory(this.repo);

  Stream<List<CategoryModel>> call() => repo.getCategory();
}
