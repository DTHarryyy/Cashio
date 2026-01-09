import 'package:cashio/features/dashboard/model/monthly_total.dart';
import 'package:cashio/features/transactions/repository/transactions_repository.dart';

class GetLast3monthsTotal {
  final TransactionsRepository repo;

  GetLast3monthsTotal(this.repo);

  Future<List<MonthlyTotal>> call(String userId) =>
      repo.getMonthlyTotal(userId);
}
