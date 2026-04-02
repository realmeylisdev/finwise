import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/account/domain/entities/account_entity.dart';
import 'package:finwise/features/account/domain/repositories/account_repository.dart';
import 'package:finwise/features/account/domain/usecases/create_account_usecase.dart';
import 'package:finwise/features/account/domain/usecases/delete_account_usecase.dart';
import 'package:finwise/features/account/domain/usecases/get_accounts_usecase.dart';
import 'package:finwise/features/account/domain/usecases/update_account_usecase.dart';
import 'package:injectable/injectable.dart';

part 'account_event.dart';
part 'account_state.dart';

@injectable
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc({
    required GetAccountsUseCase getAccounts,
    required CreateAccountUseCase createAccount,
    required UpdateAccountUseCase updateAccount,
    required DeleteAccountUseCase deleteAccount,
    required AccountRepository repository,
  })  : _getAccounts = getAccounts,
        _createAccount = createAccount,
        _updateAccount = updateAccount,
        _deleteAccount = deleteAccount,
        _repository = repository,
        super(const AccountState()) {
    on<AccountsLoaded>(_onLoaded, transformer: droppable());
    on<AccountCreated>(_onCreated, transformer: droppable());
    on<AccountUpdated>(_onUpdated, transformer: droppable());
    on<AccountDeleted>(_onDeleted, transformer: droppable());
  }

  final GetAccountsUseCase _getAccounts;
  final CreateAccountUseCase _createAccount;
  final UpdateAccountUseCase _updateAccount;
  final DeleteAccountUseCase _deleteAccount;
  final AccountRepository _repository;

  Future<void> _onLoaded(
    AccountsLoaded event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    final result = await _getAccounts(const NoParams());
    final balanceResult = await _repository.getTotalBalance();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AccountStatus.failure,
          failureMessage: failure.message,
        ),
      ),
      (accounts) => emit(
        state.copyWith(
          status: AccountStatus.success,
          accounts: accounts,
          totalBalance: balanceResult.getOrElse((_) => 0),
        ),
      ),
    );
  }

  Future<void> _onCreated(
    AccountCreated event,
    Emitter<AccountState> emit,
  ) async {
    final result = await _createAccount(event.account);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AccountStatus.failure,
          failureMessage: failure.message,
        ),
      ),
      (_) => add(const AccountsLoaded()),
    );
  }

  Future<void> _onUpdated(
    AccountUpdated event,
    Emitter<AccountState> emit,
  ) async {
    final result = await _updateAccount(event.account);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AccountStatus.failure,
          failureMessage: failure.message,
        ),
      ),
      (_) => add(const AccountsLoaded()),
    );
  }

  Future<void> _onDeleted(
    AccountDeleted event,
    Emitter<AccountState> emit,
  ) async {
    final result = await _deleteAccount(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AccountStatus.failure,
          failureMessage: failure.message,
        ),
      ),
      (_) => add(const AccountsLoaded()),
    );
  }
}
