import 'package:cashio/features/home/model/transactions.dart';
import 'package:cashio/features/home/repository/transactions_repository.dart';

class GetAllTransactions {
  final TransactionsRepository repo;

  GetAllTransactions(this.repo);

  Stream<List<Transactions>> call(String userId) =>
      repo.getAllTransactions(userId);
}
