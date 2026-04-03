import 'package:drift/drift.dart';

@DataClassName('TransactionSplitRow')
class TransactionSplits extends Table {
  TextColumn get id => text()();
  TextColumn get transactionId => text()();
  TextColumn get categoryId => text()();
  RealColumn get amount => real()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
