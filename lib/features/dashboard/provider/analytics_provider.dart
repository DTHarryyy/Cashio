import 'package:cashio/core/provider/supabase_provider.dart';
import 'package:cashio/features/dashboard/model/account_overview.dart';
import 'package:cashio/features/dashboard/repository/analytics_repository.dart';
import 'package:cashio/features/dashboard/usecases/get_monthly_overview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final analyticsRepoProvider = Provider(
  (ref) => AnalyticsRepository(ref.watch(supabaseProvider)),
);

// GET LAST 12 MONTHS
final getMonthlyOverviewUsecaseProvider = Provider(
  (ref) => GetMonthlyOverview(ref.watch(analyticsRepoProvider)),
);
final getMonthlyOverviewProvider =
    FutureProvider.family<List<MonthlyOverview>, String>((ref, userId) {
      final useCase = ref.read(getMonthlyOverviewUsecaseProvider);
      return useCase(userId);
    });
