import 'package:cashio/features/home/model/transaction.dart';
import 'package:cashio/features/home/repository/transactions_repository.dart';

class AddTransaction {
  final TransactionsRepository repo;

  AddTransaction(this.repo);

  Future<void> call(Transaction transac) => repo.addTransaction(transac);
}
