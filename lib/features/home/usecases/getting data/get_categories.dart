import 'package:cashio/features/home/model/category_model.dart';
import 'package:cashio/features/home/repository/transactions_repository.dart';

class GetCategories {
  final TransactionsRepository repo;
  GetCategories(this.repo);

  Future<List<CategoryModel>> call(String userId) => repo.getCategories(userId);
}
