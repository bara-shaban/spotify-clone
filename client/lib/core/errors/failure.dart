/// Base class for representing failures in the application.
class Failure implements Exception {
  /// Creates a [Failure] instance.
  const Failure(this.message, [this.stackTrace]);

  /// The failure message.
  final String message;

  /// Returns a string representation of the failure.
  final StackTrace? stackTrace;

  @override
  String toString() => 'Failure: $message';
}
