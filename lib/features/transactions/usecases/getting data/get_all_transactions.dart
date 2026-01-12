import 'package:cashio/features/transactions/model/transaction.dart';
import 'package:cashio/features/transactions/repository/transactions_repository.dart';

class GetAllTransactions {
  final TransactionsRepository repo;

  GetAllTransactions(this.repo);

  Stream<List<Transaction>> call(String userId) =>
      repo.getAllTransactions(userId);
}
