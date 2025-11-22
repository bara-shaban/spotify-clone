/// Authentication state representation.
enum AuthStatus {
  /// Initial unknown state
  unknown,

  /// Loading state
  loading,

  /// Authenticated state
  authenticated,

  /// Unauthenticated state
  unauthenticated,

  /// Error state
  error,
}

class AuthState {
  const AuthState._({
    required this.status,

    this.message,
  });
  final AuthStatus status;

  final String? message;

  const AuthState.unknown() : this._(status: AuthStatus.unknown);
  const AuthState.loading() : this._(status: AuthStatus.loading);
  const AuthState.authenticated() : this._(status: AuthStatus.authenticated);
  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated);
  const AuthState.error(String message)
    : this._(status: AuthStatus.error, message: message);

  bool get isAuthenticated => status == AuthStatus.authenticated;
}
