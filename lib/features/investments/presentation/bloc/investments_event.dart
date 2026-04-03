part of 'investments_bloc.dart';

abstract class InvestmentsEvent extends Equatable {
  const InvestmentsEvent();
  @override
  List<Object?> get props => [];
}

class InvestmentsLoaded extends InvestmentsEvent {
  const InvestmentsLoaded();
}

class InvestmentCreated extends InvestmentsEvent {
  const InvestmentCreated(this.investment);
  final InvestmentEntity investment;
  @override
  List<Object?> get props => [investment];
}

class InvestmentUpdated extends InvestmentsEvent {
  const InvestmentUpdated(this.investment);
  final InvestmentEntity investment;
  @override
  List<Object?> get props => [investment];
}

class InvestmentDeleted extends InvestmentsEvent {
  const InvestmentDeleted(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class PriceUpdated extends InvestmentsEvent {
  const PriceUpdated({required this.id, required this.newPrice});
  final String id;
  final double newPrice;
  @override
  List<Object?> get props => [id, newPrice];
}
