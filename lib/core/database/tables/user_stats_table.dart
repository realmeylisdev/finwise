import 'package:drift/drift.dart';

@DataClassName('UserStatRow')
class UserStats extends Table {
  TextColumn get id => text()();
  TextColumn get statKey => text()();
  RealColumn get statValue => real().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {statKey},
      ];
}
