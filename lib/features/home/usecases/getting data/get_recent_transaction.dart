import 'package:cashio/features/home/model/transactions.dart';
import 'package:cashio/features/home/repository/transactions_repository.dart';

class GetRecentTransaction {
  final TransactionsRepository repo;

  GetRecentTransaction(this.repo);

  Future<List<Transactions>> call({required String userId}) =>
      repo.getRecentTransactions(userId);
}
