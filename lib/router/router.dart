import 'package:citizenwallet/router/shell.dart';
import 'package:citizenwallet/screens/landing/screen.dart';
import 'package:citizenwallet/screens/settings/screen.dart';
import 'package:citizenwallet/screens/voucher/screen.dart';
import 'package:citizenwallet/screens/vouchers/screen.dart';
import 'package:citizenwallet/services/preferences/preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter(
  GlobalKey<NavigatorState> rootNavigatorKey,
  GlobalKey<NavigatorState> shellNavigatorKey,
  List<NavigatorObserver> observers,
) =>
    GoRouter(
      initialLocation: PreferencesService().onboarded ? '/vouchers' : '/',
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
              path: '/vouchers',
              parentNavigatorKey: shellNavigatorKey,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                name: state.name,
                child: const VouchersScreen(),
              ),
              routes: [
                GoRoute(
                  name: 'Voucher',
                  path: ':contract_id/:voucher_id',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => VoucherScreen(
                    contractId: state.params['contract_id'] ?? '',
                    voucherId: state.params['voucher_id'] ?? '',
                  ),
                ),
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
