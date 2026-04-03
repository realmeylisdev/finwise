import 'package:equatable/equatable.dart';

class DebtPaymentEntity extends Equatable {
  const DebtPaymentEntity({
    required this.id,
    required this.debtId,
    required this.amount,
    required this.date,
    this.note,
  });

  final String id;
  final String debtId;
  final double amount;
  final DateTime date;
  final String? note;

  DebtPaymentEntity copyWith({
    String? id,
    String? debtId,
    double? amount,
    DateTime? date,
    String? note,
  }) {
    return DebtPaymentEntity(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [id, debtId, amount, date, note];
}
