/// A generic result class to represent success or failure of an operation.
sealed class Result<T> {
  /// Creates a [Result] instance.
  const Result();

  /// Pattern matches on the result type and
  /// executes the corresponding function.
  R when<R>({
    required R Function(T value) ok,
    required R Function(String err) err,
  }) {
    final self = this;
    if (self is Ok<T>) return ok(self.data);
    return err((self as Err<T>).message);
  }

  /// Checks if the result is a success.
  bool get isOk => this is Ok<T>;

  /// Checks if the result is a failure.
  bool get isErr => this is Err<T>;
}

/// Represents a successful result.
class Ok<T> extends Result<T> {
  /// Creates a [Ok] instance.
  const Ok(this.data);

  /// The successful result data.
  final T data;
}

/// Represents a failure result.
class Err<T> extends Result<T> {
  /// Creates a [Err] instance.
  const Err(this.message);

  /// The error message.
  final String message;
}
