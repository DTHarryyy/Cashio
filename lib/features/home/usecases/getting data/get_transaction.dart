import 'package:cashio/features/home/model/transactions.dart';
import 'package:cashio/features/home/repository/transactions_repository.dart';

class GetTransaction {
  final TransactionsRepository repo;

  GetTransaction(this.repo);

  Stream<List<Transactions>> call({required String userId}) =>
      repo.getTransactions(userId);
}
