part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();
  @override
  List<Object?> get props => [];
}

class AccountsLoaded extends AccountEvent {
  const AccountsLoaded();
}

class AccountCreated extends AccountEvent {
  const AccountCreated(this.account);
  final AccountEntity account;
  @override
  List<Object?> get props => [account];
}

class AccountUpdated extends AccountEvent {
  const AccountUpdated(this.account);
  final AccountEntity account;
  @override
  List<Object?> get props => [account];
}

class AccountDeleted extends AccountEvent {
  const AccountDeleted(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}
