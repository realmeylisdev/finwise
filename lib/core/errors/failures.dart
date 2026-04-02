import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({this.message = 'An error occurred'});

  final String message;

  @override
  List<Object?> get props => [message];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({super.message = 'Database error occurred'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Validation failed',
    this.fieldErrors,
  });

  final Map<String, String>? fieldErrors;

  @override
  List<Object?> get props => [message, fieldErrors];
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Resource not found'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred'});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'An unexpected error occurred'});
}
