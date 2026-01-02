import 'package:cashio/features/home/model/transaction.dart';
import 'package:cashio/features/home/repository/transactions_repository.dart';

class GetAllTransactions {
  final TransactionsRepository repo;

  GetAllTransactions(this.repo);

  Stream<List<Transaction>> call(String userId) =>
      repo.getAllTransactions(userId);
}
