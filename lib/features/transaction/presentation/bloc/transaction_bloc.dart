import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:finwise/features/transaction/domain/usecases/create_transaction_usecase.dart';
import 'package:finwise/features/transaction/domain/usecases/delete_transaction_usecase.dart';
import 'package:finwise/features/transaction/domain/usecases/get_transactions_usecase.dart';
import 'package:injectable/injectable.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

@injectable
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc({
    required GetTransactionsUseCase getTransactions,
    required CreateTransactionUseCase createTransaction,
    required DeleteTransactionUseCase deleteTransaction,
    required TransactionRepository repository,
  })  : _getTransactions = getTransactions,
        _createTransaction = createTransaction,
        _deleteTransaction = deleteTransaction,
        _repository = repository,
        super(const TransactionState()) {
    on<TransactionsLoaded>(_onLoaded, transformer: droppable());
    on<TransactionCreated>(_onCreated, transformer: droppable());
    on<TransactionUpdated>(_onUpdated, transformer: droppable());
    on<TransactionDeleted>(_onDeleted, transformer: droppable());
    on<TransactionDateRangeChanged>(
      _onDateRangeChanged,
      transformer: droppable(),
    );
  }

  final GetTransactionsUseCase _getTransactions;
  final CreateTransactionUseCase _createTransaction;
  final DeleteTransactionUseCase _deleteTransaction;
  final TransactionRepository _repository;

  Future<void> _onLoaded(
    TransactionsLoaded event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    final result = await _getTransactions(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TransactionStatus.failure,
          failureMessage: failure.message,
        ),
      ),
      (transactions) => emit(
        state.copyWith(
          status: TransactionStatus.success,
          transactions: transactions,
        ),
      ),
    );
  }

  Future<void> _onCreated(
    TransactionCreated event,
    Emitter<TransactionState> emit,
  ) async {
    final result = await _createTransaction(event.transaction);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TransactionStatus.failure,
          failureMessage: failure.message,
        ),
      ),
      (_) => add(const TransactionsLoaded()),
    );
  }

  Future<void> _onUpdated(
    TransactionUpdated event,
    Emitter<TransactionState> emit,
  ) async {
    final result = await _repository.updateTransaction(event.transaction);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TransactionStatus.failure,
          failureMessage: failure.message,
        ),
      ),
      (_) => add(const TransactionsLoaded()),
    );
  }

  Future<void> _onDeleted(
    TransactionDeleted event,
    Emitter<TransactionState> emit,
  ) async {
    final result = await _deleteTransaction(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TransactionStatus.failure,
          failureMessage: failure.message,
        ),
      ),
      (_) => add(const TransactionsLoaded()),
    );
  }

  Future<void> _onDateRangeChanged(
    TransactionDateRangeChanged event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    final result = await _repository.getTransactionsByDateRange(
      event.start,
      event.end,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TransactionStatus.failure,
          failureMessage: failure.message,
        ),
      ),
      (transactions) => emit(
        state.copyWith(
          status: TransactionStatus.success,
          transactions: transactions,
        ),
      ),
    );
  }
}
