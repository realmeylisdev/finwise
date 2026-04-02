import 'package:drift/drift.dart';
import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/daos/accounts_dao.dart';
import 'package:finwise/features/account/domain/entities/account_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class AccountLocalDatasource {
  AccountLocalDatasource(this._dao);

  final AccountsDao _dao;

  Future<List<AccountEntity>> getAccounts() async {
    final rows = await _dao.getAllAccounts();
    return rows.map(_toEntity).toList();
  }

  Stream<List<AccountEntity>> watchAccounts() {
    return _dao.watchAllAccounts().map(
          (rows) => rows.map(_toEntity).toList(),
        );
  }

  Future<AccountEntity?> getAccountById(String id) async {
    final row = await _dao.getAccountById(id);
    return row == null ? null : _toEntity(row);
  }

  Future<void> insertAccount(AccountEntity entity) async {
    await _dao.insertAccount(
      AccountsCompanion.insert(
        id: entity.id,
        name: entity.name,
        type: AccountEntity.typeToString(entity.type),
        balance: Value(entity.balance),
        currencyCode: entity.currencyCode,
        icon: Value(entity.icon),
        color: Value(entity.color),
        includeInTotal: Value(entity.includeInTotal),
        sortOrder: Value(entity.sortOrder),
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      ),
    );
  }

  Future<void> updateAccount(AccountEntity entity) async {
    await _dao.updateAccount(
      AccountsCompanion(
        id: Value(entity.id),
        name: Value(entity.name),
        type: Value(AccountEntity.typeToString(entity.type)),
        icon: Value(entity.icon),
        color: Value(entity.color),
        includeInTotal: Value(entity.includeInTotal),
        isArchived: Value(entity.isArchived),
        sortOrder: Value(entity.sortOrder),
        updatedAt: Value(entity.updatedAt),
      ),
    );
  }

  Future<void> deleteAccount(String id) async {
    await _dao.deleteAccount(id);
  }

  Future<double> getTotalBalance() async {
    return _dao.getTotalBalance();
  }

  AccountEntity _toEntity(AccountRow row) {
    return AccountEntity(
      id: row.id,
      name: row.name,
      type: AccountEntity.typeFromString(row.type),
      balance: row.balance,
      currencyCode: row.currencyCode,
      icon: row.icon,
      color: row.color,
      includeInTotal: row.includeInTotal,
      isArchived: row.isArchived,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
