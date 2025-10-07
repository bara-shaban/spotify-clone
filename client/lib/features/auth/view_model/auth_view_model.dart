import 'dart:developer' as devtools show log;
import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_view_model.g.dart';

/// A view model that manages authentication state.
@riverpod
class AuthViewModel extends _$AuthViewModel {
  final AuthRemoteRepository _authRemoteRepository = AuthRemoteRepository();

  /// Signs up a new user.
  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();
      final response = await _authRemoteRepository.signup(
        name: name,
        email: email,
        password: password,
      );

      state = AsyncValue.data(response);
      devtools.log('User signed up: $response');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      devtools.log('Error signing up user: $e');
      rethrow;
    }
  }

  @override
  AsyncValue<UserModel> build() {
    return const AsyncValue.data(
      UserModel(id: '1', name: 'Bara', email: 'bara@example.com'),
    );
  }
}
