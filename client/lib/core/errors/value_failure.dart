import 'package:client/core/errors/failure.dart';

class ValueFailure extends Failure {
  const ValueFailure(super.message, [super.stackTrace]);
}

class InvalidUniqueIdFalure extends ValueFailure {
  const InvalidUniqueIdFalure([StackTrace? stackTrace])
    : super('Invalid Uniqe ID', stackTrace);
}

class EmptyStringFailure extends Failure {
  const EmptyStringFailure([StackTrace? stackTrace])
    : super('String cannot be empty', stackTrace);
}
