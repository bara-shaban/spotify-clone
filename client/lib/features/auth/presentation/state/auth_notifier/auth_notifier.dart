import 'package:client/app/di/di.dart';
import 'package:client/features/auth/domain/failures/auth_failure.dart';
import 'package:client/features/auth/domain/failures/auth_value_failure.dart';
import 'package:client/features/auth/presentation/state/auth_state/auth_state.dart';
import 'package:pedantic/pedantic.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

/// Notifier that manages the authentication state.
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    unawaited(_checkAuthStatus());
    return const AuthState.unknown();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isValid = await ref
          .read(isCachedRefreshTokenValidUsecaseProvider)
          .call();
      if (isValid) {
        state = const AuthState.authenticated();
      } else {
        state = const AuthState.unauthenticated();
      }
    } on AuthValueFailure catch (e) {
      state = AuthState.error(e.toString());
    } on NetworkFailure catch (e) {
      state = AuthState.error(e.toString());
    } on AuthFailure {
      state = const AuthState.unauthenticated();
    } /*  on InvalidRefreshTokenFailure {
      // thinking of showing an enter password screen here instead of going
      // straight to unauthenticated
      state = const AuthState.unauthenticated();
    } */
    /// on any other failure, set error state
    // ignore: avoid_catches_without_on_clauses
    catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Signs up a new user with the provided [name], [email], and [password].
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      await ref
          .read(signupUsecaseProvider)
          .call(name: name, email: email, password: password);
      state = const AuthState.authenticated();
    }
    /// on any other failure, set error state
    // ignore: avoid_catches_without_on_clauses
    catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Logs out the current user by clearing cached authentication data.
  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      // TODO: fix this to use usecase
      await ref.read(authRepositoryProvider).clearCachedData();
      state = const AuthState.unauthenticated();
    }
    /// on any other failure, set error state
    // ignore: avoid_catches_without_on_clauses
    catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Mock authenticate for testing purposes.
  Future<void> mockAuthenticate() async {
    state = const AuthState.authenticated();
  }
}
