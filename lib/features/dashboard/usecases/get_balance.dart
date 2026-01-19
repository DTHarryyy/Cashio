import 'package:cashio/features/dashboard/model/balance.dart';
import 'package:cashio/features/dashboard/repository/balance_repository.dart';

class GetBalance {
  final BalaceRepository repo;
  GetBalance(this.repo);

  Stream<List<Balance>> call(String userId) => repo.getBalance(userId);
}
