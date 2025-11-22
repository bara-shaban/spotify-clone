import 'package:client/app/di/di.dart';
import 'package:client/features/auth/Presentation/auth_state/auth_state.dart';
import 'package:client/features/auth/domain/failures/auth_failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AuthState> build() async {
    final isRefreshTokenvalid = await ref
        .watch(isCachedRefreshTokenValidUsecaseProvider)
        .call();
    try {
      if (isRefreshTokenvalid) return const AuthState.authenticated();
      return const AuthState.unauthenticated();
    } on InvalidRefreshTokenFailure catch (e) {
      // I am thinking of showing a UI that tells
      // the user to re-enter the password only
      return const AuthState.unauthenticated();
    } catch (e) {
      return AuthState.error(e.toString());
    }
  }
}

/* 

 */
