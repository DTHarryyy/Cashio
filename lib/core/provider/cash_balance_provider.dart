import 'package:cashio/core/provider/supabase_provider.dart';
import 'package:cashio/core/repository/balance_repository.dart';
import 'package:cashio/core/use%20case/update_cash_balance.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final balanceRepoProv = Provider(
  (ref) => BalanceRepo(ref.read(supabaseProvider)),
);

final addIncomeInBalanceProvider = Provider(
  (ref) => AddIncomeInBalance(ref.read(balanceRepoProv)),
);

final lessExpenseInBalanceProvider = Provider(
  (ref) => LessExpenseInBalance(ref.read(balanceRepoProv)),
);
