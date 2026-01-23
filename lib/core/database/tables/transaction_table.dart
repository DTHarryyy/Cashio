import 'package:drift/drift.dart';

class TransactionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().named('user_id')();
  RealColumn get amount => real()();
  TextColumn get description => text().nullable()();

  DateTimeColumn get transactionDate =>
      dateTime().nullable().named('transaction_date')();

  DateTimeColumn get createdAt => dateTime().named('created_at')();

  TextColumn get transactionName => text().named('transaction_name')();

  TextColumn get budgetId => text().nullable().named('budget_id')();
  TextColumn get categoryId => text().named('category_id')();
  TextColumn get type => text()();
  TextColumn get goalId => text().nullable().named('goal_id')();

  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false)).named('is_synced')();

  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false)).named('is_deleted')();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime).named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}
