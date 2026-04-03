import 'package:drift/drift.dart';

@DataClassName('NotificationRow')
class Notifications extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()(); // budget_alert, bill_reminder, insight, goal_milestone, weekly_digest, achievement
  TextColumn get title => text()();
  TextColumn get body => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  TextColumn get data => text().nullable()(); // JSON payload for deep-linking
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
