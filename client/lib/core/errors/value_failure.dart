import 'package:client/core/errors/failure.dart';

class ValueFailure extends Failure {
  const ValueFailure(super.message, [super.stackTrace]);
}

class InvalidUniqueIdFailure extends ValueFailure {
  const InvalidUniqueIdFailure([StackTrace? stackTrace])
    : super('Invalid Unique ID', stackTrace);
}

class EmptyStringFailure extends Failure {
  const EmptyStringFailure([StackTrace? stackTrace])
    : super('String cannot be empty', stackTrace);
}
