import 'package:citizenwallet/router/shell.dart';
import 'package:citizenwallet/screens/landing/screen.dart';
import 'package:citizenwallet/screens/settings/screen.dart';
import 'package:citizenwallet/screens/vouchers/screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter(
  GlobalKey<NavigatorState> rootNavigatorKey,
  GlobalKey<NavigatorState> shellNavigatorKey,
  List<NavigatorObserver> observers,
) =>
    GoRouter(
      // initialLocation: '/',
      initialLocation: '/vouchers/:address',
      debugLogDiagnostics: kDebugMode,
      navigatorKey: rootNavigatorKey,
      observers: observers,
      routes: [
        GoRoute(
          name: 'Landing',
          path: '/',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const LandingScreen(),
        ),
        ShellRoute(
          navigatorKey: shellNavigatorKey,
          builder: (context, state, child) => RouterShell(
            state: state,
            child: child,
          ),
          routes: [
            GoRoute(
              name: 'Vouchers',
              path: '/vouchers/:address',
              parentNavigatorKey: shellNavigatorKey,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                name: state.name,
                child: VouchersScreen(
                  address: state.params['address'] ?? '0x0',
                ),
              ),
              routes: [
                // GoRoute(
                //   name: 'Transaction',
                //   path: 'transactions/:transactionId',
                //   parentNavigatorKey: rootNavigatorKey,
                //   builder: (context, state) {
                //     if (state.extra == null) {
                //       return const SizedBox();
                //     }

                //     final extra = state.extra as Map<String, dynamic>;

                //     return TransactionScreen(
                //       transactionId: state.params['transactionId'],
                //       logic: extra['logic'],
                //     );
                //   },
                // ),
              ],
            ),
            GoRoute(
              name: 'Settings',
              path: '/settings',
              parentNavigatorKey: shellNavigatorKey,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                name: state.name,
                child: const SettingsScreen(),
              ),
            ),
          ],
        ),
      ],
    );
