import 'package:equatable/equatable.dart';
import 'package:finwise/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

abstract class UseCaseStream<T, Params> {
  Stream<Either<Failure, T>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
