import 'package:client/core/providers/env_provider.dart';
import 'package:client/features/auth/Presentation/auth_notifier/auth_notifier.dart';
import 'package:client/features/auth/Presentation/auth_state/auth_state.dart';
import 'package:client/features/auth/signup/ui/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(this.ref) {
    final initial = ref.read(authProvider);
    _isLoggedIn = initial.asData?.value.isAuthenticated ?? false;

    _removeListener = ref.listen<AsyncValue<AuthState>>(authProvider, (
      _,
      next,
    ) {
      final loggedIn = next.asData?.value.isAuthenticated ?? false;
      if (loggedIn != _isLoggedIn) {
        _isLoggedIn = loggedIn;
        notifyListeners();
      }
    }).close;
  }
  final Ref ref;
  late final VoidCallback _removeListener;
  bool _isLoggedIn = false;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
}

final authListenableProvider = Provider.autoDispose<_AuthListenable>(
  (ref) {
    final listenable = _AuthListenable(ref);
    ref.onDispose(listenable.dispose);
    return listenable;
  },
);

final routerProvider = Provider<GoRouter>(
  (ref) {
    final envVerbose = ref.watch(envProvider).verboseLogging;
    final authListenable = ref.watch(authListenableProvider);

    return GoRouter(
      initialLocation: '/login',
      debugLogDiagnostics: envVerbose,
      refreshListenable: authListenable,
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('Login Page'),
                ),
              ),
            );
          },
        ),
      ],
      redirect: (context, state) {
        final isLoggedIn = authListenable._isLoggedIn;
        final goingToLogin = state.matchedLocation == '/login';

        if (!isLoggedIn && !goingToLogin) {
          return '/login';
        } else if (isLoggedIn && goingToLogin) {
          return '/';
        }
        return null;
      },
    );
  },
);
