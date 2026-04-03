import 'package:equatable/equatable.dart';

class TransactionSplitEntity extends Equatable {
  const TransactionSplitEntity({
    required this.id,
    required this.transactionId,
    required this.categoryId,
    required this.amount,
    this.note,
    this.categoryName,
    this.categoryIcon,
    this.categoryColor,
  });

  final String id;
  final String transactionId;
  final String categoryId;
  final double amount;
  final String? note;
  final String? categoryName;
  final String? categoryIcon;
  final int? categoryColor;

  @override
  List<Object?> get props => [id, transactionId, categoryId, amount, note];
}
