import 'package:cashio/features/dashboard/model/account_overview.dart';
import 'package:cashio/features/dashboard/repository/analytics_repository.dart';

class GetMonthlyOverview {
  final AnalyticsRepository repo;
  GetMonthlyOverview(this.repo);

  Future<List<MonthlyOverview>> call(String userId) =>
      repo.getMonthlyOverview(userId);
}
