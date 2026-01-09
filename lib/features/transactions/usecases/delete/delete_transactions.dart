import 'package:cashio/features/transactions/repository/transactions_repository.dart';

class DeleteTransactions {
  final TransactionsRepository repo;
  DeleteTransactions(this.repo);
  Future<void> call(String transactionId) =>
      repo.deleteTransaction(transactionId);
}
