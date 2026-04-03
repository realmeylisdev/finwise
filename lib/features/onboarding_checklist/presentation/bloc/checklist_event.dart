part of 'checklist_bloc.dart';

abstract class ChecklistEvent extends Equatable {
  const ChecklistEvent();
  @override
  List<Object?> get props => [];
}

class ChecklistLoaded extends ChecklistEvent {
  const ChecklistLoaded();
}
