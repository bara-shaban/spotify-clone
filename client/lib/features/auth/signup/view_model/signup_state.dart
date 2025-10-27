import 'package:client/features/auth/domain/entities/user.dart';

/// State class for SignUp
class SignUpState {
  /// Creates a [SignUpState].
  const SignUpState({
    required this.loading,
    required this.user,
    required this.error,
  });

  /// Creates an initial [SignUpState] with default values.
  factory SignUpState.initial() => const SignUpState(
    loading: false,
    user: null,
    error: null,
  );

  /// Indicates if a sign-up operation is in progress.
  final bool loading;

  /// The signed-up user information.
  final User? user;

  /// An optional error message if the sign-up operation failed.
  final String? error;

  /// whether there is an error or not
  bool get hasError => error != null;

  /// Creates a copy of the current [SignUpState]
  /// instance with optional new values.
  SignUpState copyWith({
    required bool clearError,
    bool? loading,
    User? user,
    String? error,
  }) {
    return SignUpState(
      loading: loading ?? this.loading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}
