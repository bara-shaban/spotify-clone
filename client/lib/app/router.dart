import 'package:client/core/providers/env_provider.dart';
import 'package:client/core/providers/logger_provider.dart';
import 'package:client/features/auth/Presentation/ui/login_view.dart';
import 'package:client/features/auth/presentation/state/auth_notifier/auth_notifier.dart';
import 'package:client/features/auth/presentation/state/auth_state/auth_state.dart';
import 'package:client/features/auth/presentation/ui/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class _AuthNotifierListenable extends ChangeNotifier {
  _AuthNotifierListenable(this.ref) {
    _authState = ref.read(authProvider);
    _removeListener = ref.listen<AuthState>(
      authProvider,
      (previous, next) {
        if (previous != next) {
          _authState = next;
          notifyListeners();
        }
      },
    ).close;
  }

  final Ref ref;
  late final VoidCallback _removeListener;
  AuthState _authState = const AuthState.unknown();

  AuthState get authState => _authState;

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
}

/// Provider for the auth listenable
final Provider<_AuthNotifierListenable> _authListenableProvider =
    Provider.autoDispose<_AuthNotifierListenable>(
      (ref) {
        final listenable = _AuthNotifierListenable(ref);
        ref.onDispose(listenable.dispose);
        return listenable;
      },
    );

/// Provider for the app router,
/// managing navigation and redirection based on auth state.
final routerProvider = Provider<GoRouter>(
  (ref) {
    final envVerbose = ref.watch(envProvider).verboseLogging;
    final notifier = ref.read(authProvider.notifier);
    final authListenable = ref.watch(_authListenableProvider);
    return GoRouter(
      initialLocation: '/splash',
      debugLogDiagnostics: envVerbose,
      refreshListenable: authListenable,
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: TextButton(
                    onPressed: () async {
                      await notifier.logout();
                    },
                    child: const Text('Splash Screen'),
                  ),
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) {
            return Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () async {
                    await notifier.logout();
                  },
                  child: const Text('Home Page'),
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LogInPage(),
        ),
      ],
      redirect: (context, state) {
        final authState = authListenable.authState;
        final currentPath = state.matchedLocation;
        return authState.when(
          unknown: () => currentPath != '/splash' ? '/splash' : null,
          loading: () => null,
          authenticated: () {
            if (currentPath == '/login' ||
                currentPath == '/splash' ||
                currentPath == '/signup') {
              return '/';
            }
            return null;
          },
          unauthenticated: () {
            if (currentPath != '/login' && currentPath != '/signup') {
              return '/login';
            }
            return null;
          },
          error: (_) => null,
        );
      },
    );
  },
);

/* import 'package:client/app/di/di.dart';
import 'package:client/core/providers/env_provider.dart';
import 'package:client/features/auth/presentation/state/auth_notifier/auth_notifier.dart';
import 'package:client/features/auth/presentation/state/auth_state/auth_state.dart';
import 'package:client/features/auth/presentation/ui/signup_view.dart';
import 'package:client/features/auth/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Listenable that notifies GoRouter when auth state changes
class _AuthNotifierListenable extends ChangeNotifier {
  _AuthNotifierListenable(this.ref) {
    // Read initial auth state
    _authState = ref.read(authProvider);

    // Listen for auth state changes and notify GoRouter
    _removeListener = ref.listen<AuthState>(
      authProvider,
      (previous, next) {
        if (previous != next) {
          _authState = next;
          notifyListeners(); // Tell GoRouter to re-run redirect
        }
      },
    ).close;
  }

  final Ref ref;
  late final VoidCallback _removeListener;
  AuthState _authState = const AuthState.unknown();

  /// Public getter for current auth state
  AuthState get authState => _authState;

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
}

/// Provider for the auth listenable
final authListenableProvider = Provider.autoDispose<_AuthNotifierListenable>(
  (ref) {
    final listenable = _AuthNotifierListenable(ref);
    ref.onDispose(listenable.dispose);
    return listenable;
  },
);

final routerProvider = Provider<GoRouter>(
  (ref) {
    final envVerbose = ref.watch(envProvider).verboseLogging;
    final repo = ref.watch(authRepositoryProvider);

    // Get the listenable for GoRouter to watch
    final authListenable = ref.watch(authListenableProvider);

    return GoRouter(
      initialLocation: '/splash',
      debugLogDiagnostics: envVerbose,

      // This tells GoRouter to re-run redirect when notified
      refreshListenable: authListenable,

      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: TextButton(
                    onPressed: () async {
                      await repo.clearCachedData();
                    },
                    child: const Text('Splash Screen'),
                  ),
                ),
              ),
            );
          },
        ),
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
        // Use ref.read() here, NOT ref.watch()!
        // refreshListenable handles the rebuild trigger
        final authState = authListenable.authState;
        final currentPath = state.matchedLocation;

        return authState.when(
          unknown: () => currentPath != '/splash' ? '/splash' : null,
          loading: () => currentPath != '/splash' ? '/splash' : null,
          authenticated: () {
            if (currentPath == '/login' ||
                currentPath == '/splash' ||
                currentPath == '/signup') {
              return '/';
            }
            return null;
          },
          unauthenticated: () {
            if (currentPath != '/login' && currentPath != '/signup') {
              return '/login';
            }
            return null;
          },
          error: (_) => null,
        );
      },
    );
  },
);
 */
