import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

/// Represents the various states of authentication.
@freezed
class AuthState with _$AuthState {
  /// Represents an unknown authentication state.
  const factory AuthState.unknown() = _Unknown;

  /// Represents a loading authentication state.
  const factory AuthState.loading() = _Loading;

  /// Represents an authenticated state.
  const factory AuthState.authenticated() = _Authenticated;

  /// Represents an unauthenticated state.
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// Represents an error state with a message.
  const factory AuthState.error(String message) = _Error;
}

/// Extension on [AuthState] to provide additional utility methods.
extension AuthStateX on AuthState {
  /// Checks if the current state is authenticated.
  bool get isAuthenticated => maybeWhen(
    authenticated: () => true,
    orElse: () => false,
  );
}
