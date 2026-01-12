import 'package:cashio/features/transactions/model/transaction.dart';
import 'package:cashio/features/transactions/repository/transactions_repository.dart';

class AddTransaction {
  final TransactionsRepository repo;

  AddTransaction(this.repo);

  Future<void> call(Transaction transac) => repo.addTransaction(transac);
}
