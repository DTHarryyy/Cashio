import 'package:cashio/features/home/repository/transactions_repository.dart';

class AddTransaction {
  final TransactionsRepository repo;

  AddTransaction(this.repo);

  Future<void> call({
    required String transactionName,
    required String userId,
    required double amount,
    required String categoryId,
    required String note,
    required DateTime? transactionDate,
  }) => repo.addTransaction(
    transactionName: transactionName,
    userId: userId,
    amount: amount,
    note: note,
    categoryId: categoryId,
    transactionDate: transactionDate,
  );
}
