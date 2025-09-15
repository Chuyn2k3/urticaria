import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:urticaria/cubit/auth/auth_cubit.dart';
import 'package:urticaria/cubit/register_account/register_account_cubit.dart';
import 'package:urticaria/feature/bottom_nav/bottom_nav_page.dart';
import 'package:urticaria/feature/live/agora_config.dart';
import 'package:urticaria/feature/live/live_detail_page.dart';
import 'package:urticaria/feature/live/live_page.dart';
import 'package:urticaria/feature/register/register_screen.dart';
import 'package:urticaria/router/go_router_name_enum.dart';
import 'package:urticaria/screens/login_page.dart';
import 'package:urticaria/utils/go_router/custom_transition.dart';
import 'package:urticaria/utils/go_router/enum.dart';
import 'package:urticaria/utils/navigation_service.dart';

class AppRouter {
  final AuthCubit authCubit;

  AppRouter(this.authCubit);

  late final GoRouter router = GoRouter(
    navigatorKey: GetIt.instance<NavigationService>().navigatorKey,
    routerNeglect: true,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text("Page not found"))),
    routes: <GoRoute>[
      GoRoute(
        path: GoRouterName.login.routePath,
        name: GoRouterName.login.routeName,
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: LoginPage(),
        ),
      ),
      // GoRoute(
      //   path: GoRouterName.live.routePath,
      //   name: GoRouterName.live.routeName,
      //   pageBuilder: (context, state) => const NoTransitionPage<void>(
      //     child: LivePage(),
      //   ),
      // ),
      // GoRoute(
      //   path: GoRouterName.liveDetail.routePath,
      //   name: GoRouterName.liveDetail.routeName,
      //   pageBuilder: (context, state) => NoTransitionPage<void>(
      //     child: LiveDetailPage(config: state.extra as AgoraConfig),
      //   ),
      // ),
      GoRoute(
        path: GoRouterName.register.routePath,
        name: GoRouterName.register.routeName,
        pageBuilder: (context, state) => buildPageWithTransition(
          child: BlocProvider(
            create: (_) => RegisterAccountCubit(),
            child: const RegisterScreen(),
          ),
          type: RouteTransitionType.fadeScale,
        ),
      ),
      GoRoute(
        path: GoRouterName.home.routePath,
        name: GoRouterName.home.routeName,
        pageBuilder: (context, state) => buildPageWithTransition(
          child: const BottomNavPage(),
          type: RouteTransitionType
              .slideBottomToTop, // hoặc slideRightToLeft nếu muốn hiệu ứng trượt
        ),
      ),
    ],
    redirect: (_, state) {
      final isLogin = authCubit.state.isLogin;
      final bool loggingIn = state.subloc == GoRouterName.login.routePath ||
          state.subloc == GoRouterName.register.routePath;
      //||
      // state.subloc == GoRouterName.forgotPassword.routePath ||
      // state.subloc == GoRouterName.otpForgot.routePath ||
      // state.subloc == GoRouterName.resetPassword.routePath ||
      // state.subloc == GoRouterName.policyUseScreen.routePath;

      if (!isLogin) {
        return loggingIn ? null : GoRouterName.login.routePath;
      }
      if (loggingIn) {
        return GoRouterName.home.routePath;
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
