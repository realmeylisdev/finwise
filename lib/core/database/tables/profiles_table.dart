import 'package:drift/drift.dart';

@DataClassName('ProfileRow')
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get email => text().nullable()();
  IntColumn get avatarColor =>
      integer().withDefault(const Constant(0xFF6366F1))();
  BoolColumn get isOwner => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
