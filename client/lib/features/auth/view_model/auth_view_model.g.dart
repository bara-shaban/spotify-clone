// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A view model that manages authentication state.

@ProviderFor(AuthViewModel)
const authViewModelProvider = AuthViewModelProvider._();

/// A view model that manages authentication state.
final class AuthViewModelProvider
    extends $NotifierProvider<AuthViewModel, AsyncValue<UserModel>> {
  /// A view model that manages authentication state.
  const AuthViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authViewModelHash();

  @$internal
  @override
  AuthViewModel create() => AuthViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<UserModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<UserModel>>(value),
    );
  }
}

String _$authViewModelHash() => r'5a94a81483456ecea7de2596e28b1c2dceb37939';

/// A view model that manages authentication state.

abstract class _$AuthViewModel extends $Notifier<AsyncValue<UserModel>> {
  AsyncValue<UserModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<UserModel>, AsyncValue<UserModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserModel>, AsyncValue<UserModel>>,
              AsyncValue<UserModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
