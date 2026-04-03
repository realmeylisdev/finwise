import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../tables/user_stats_table.dart';

part 'user_stats_dao.g.dart';

@DriftAccessor(tables: [UserStats])
class UserStatsDao extends DatabaseAccessor<AppDatabase>
    with _$UserStatsDaoMixin {
  UserStatsDao(super.db);

  Future<double> getStat(String key) async {
    final row = await (select(userStats)
          ..where((t) => t.statKey.equals(key)))
        .getSingleOrNull();
    return row?.statValue ?? 0;
  }

  Future<void> setStat(String key, double value) async {
    final existing = await (select(userStats)
          ..where((t) => t.statKey.equals(key)))
        .getSingleOrNull();

    if (existing != null) {
      await (update(userStats)
            ..where((t) => t.statKey.equals(key)))
          .write(
        UserStatsCompanion(
          statValue: Value(value),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      await into(userStats).insert(
        UserStatsCompanion.insert(
          id: const Uuid().v4(),
          statKey: key,
          statValue: Value(value),
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  Future<void> incrementStat(String key, double amount) async {
    final current = await getStat(key);
    await setStat(key, current + amount);
  }

  Future<Map<String, double>> getAllStats() async {
    final rows = await select(userStats).get();
    return {for (final row in rows) row.statKey: row.statValue};
  }
}
