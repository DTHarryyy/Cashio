import 'package:cashio/features/home/repository/transactions_repository.dart';

class GetTotalExpenses {
  final TransactionsRepository repo;
  GetTotalExpenses(this.repo);

  Future<double> call({required String userId, required String categoryType}) =>
      repo.getTotalByType(userId, categoryType);
}
