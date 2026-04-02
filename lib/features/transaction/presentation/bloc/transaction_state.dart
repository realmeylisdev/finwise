part of 'transaction_bloc.dart';

enum TransactionStatus { initial, loading, success, failure }

class TransactionState extends Equatable {
  const TransactionState({
    this.status = TransactionStatus.initial,
    this.transactions = const [],
    this.failureMessage,
  });

  final TransactionStatus status;
  final List<TransactionEntity> transactions;
  final String? failureMessage;

  /// Group transactions by date for display
  Map<DateTime, List<TransactionEntity>> get groupedByDate {
    final map = <DateTime, List<TransactionEntity>>{};
    for (final txn in transactions) {
      final key = DateTime(txn.date.year, txn.date.month, txn.date.day);
      map.putIfAbsent(key, () => []).add(txn);
    }
    return map;
  }

  TransactionState copyWith({
    TransactionStatus? status,
    List<TransactionEntity>? transactions,
    String? failureMessage,
  }) {
    return TransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [status, transactions, failureMessage];
}
