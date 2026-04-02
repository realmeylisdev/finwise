import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/accounts_table.dart';

part 'accounts_dao.g.dart';

@DriftAccessor(tables: [Accounts])
class AccountsDao extends DatabaseAccessor<AppDatabase>
    with _$AccountsDaoMixin {
  AccountsDao(super.db);

  Future<List<AccountRow>> getAllAccounts() =>
      (select(accounts)
            ..where((t) => t.isArchived.equals(false))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Stream<List<AccountRow>> watchAllAccounts() =>
      (select(accounts)
            ..where((t) => t.isArchived.equals(false))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<AccountRow?> getAccountById(String id) =>
      (select(accounts)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<AccountRow?> watchAccountById(String id) =>
      (select(accounts)..where((t) => t.id.equals(id)))
          .watchSingleOrNull();

  Future<int> insertAccount(AccountsCompanion entry) =>
      into(accounts).insert(entry);

  Future<bool> updateAccount(AccountsCompanion entry) =>
      (update(accounts)..where((t) => t.id.equals(entry.id.value)))
          .write(entry)
          .then((rows) => rows > 0);

  Future<int> deleteAccount(String id) =>
      (delete(accounts)..where((t) => t.id.equals(id))).go();

  Future<void> updateBalance(String id, double newBalance) =>
      (update(accounts)..where((t) => t.id.equals(id))).write(
        AccountsCompanion(
          balance: Value(newBalance),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<double> getTotalBalance() async {
    final allAccounts = await (select(accounts)
          ..where(
            (t) =>
                t.isArchived.equals(false) &
                t.includeInTotal.equals(true),
          ))
        .get();
    return allAccounts.fold<double>(0, (sum, a) => sum + a.balance);
  }
}
