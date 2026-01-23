import 'package:drift/drift.dart';

class CategoriesTable extends Table {
  TextColumn get id => text()(); // uuid as text

  TextColumn get categoryName => text().named('category_name')();

  IntColumn get categoryIcon =>
      integer().named('category_icon')(); // icon codePoint

  IntColumn get color => integer()(); // store ARGB int

  TextColumn get type => text()();

  DateTimeColumn get createdAt => dateTime().named('created_at')();

  // local-only sync helpers
  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false)).named('is_synced')();

  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false)).named('is_deleted')();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime).named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}
