part of 'account_bloc.dart';

enum AccountStatus { initial, loading, success, failure }

class AccountState extends Equatable {
  const AccountState({
    this.status = AccountStatus.initial,
    this.accounts = const [],
    this.totalBalance = 0,
    this.failureMessage,
  });

  final AccountStatus status;
  final List<AccountEntity> accounts;
  final double totalBalance;
  final String? failureMessage;

  AccountState copyWith({
    AccountStatus? status,
    List<AccountEntity>? accounts,
    double? totalBalance,
    String? failureMessage,
  }) {
    return AccountState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      totalBalance: totalBalance ?? this.totalBalance,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [status, accounts, totalBalance, failureMessage];
}
