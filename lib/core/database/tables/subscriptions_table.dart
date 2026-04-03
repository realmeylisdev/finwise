import 'package:drift/drift.dart';

@DataClassName('SubscriptionRow')
class Subscriptions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  RealColumn get amount => real()();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  TextColumn get billingCycle => text()(); // monthly, weekly, yearly, quarterly
  DateTimeColumn get nextBillingDate => dateTime()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get icon => text().withDefault(const Constant('subscription'))();
  IntColumn get color => integer().withDefault(const Constant(0xFF6366F1))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
