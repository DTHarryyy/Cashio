import 'package:cashio/features/transactions/repository/transactions_repository.dart';

class GetTotalExpenses {
  final TransactionsRepository repo;
  GetTotalExpenses(this.repo);

  Future<double> call({required String userId, required String categoryType}) =>
      repo.getTotalByType(userId, categoryType);
}
