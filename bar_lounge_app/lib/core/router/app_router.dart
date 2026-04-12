import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/welcome_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/reset_link_sent_screen.dart';
import '../../features/scanner/presentation/scanner_screen.dart';
import '../../features/menu/presentation/menu_screen.dart';
import '../../features/orders/presentation/bill_summary_screen.dart';
import '../../features/orders/presentation/order_history_screen.dart';
import '../../features/orders/presentation/order_receipt_screen.dart';
import '../../features/account/presentation/account_screen.dart';
import '../../features/reservations/presentation/table_reservations_screen.dart';
import '../../shared/widgets/bottom_nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // ── Auth Flow (no bottom nav) ───────────────────────────
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(errorMessage: state.extra as String?),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-link-sent',
      builder: (context, state) => const ResetLinkSentScreen(),
    ),
    // Hidden verification screen: kept in source for future use, but not part of the current signup flow.
    // GoRoute(
    //   path: '/verify-email',
    //   builder: (context, state) => const VerifyEmailScreen(),
    // ),

    // ── Order Receipt (full-screen, no bottom nav) ─────────────
    GoRoute(
      path: '/order-receipt/:uuid',
      builder: (context, state) => OrderReceiptScreen(
        facturaUuid: state.pathParameters['uuid']!,
      ),
    ),

    // ── Main App (with bottom nav) ──────────────────────────
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/menu',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MenuScreen(),
          ),
        ),
        GoRoute(
          path: '/scanner',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ScannerScreen(),
          ),
        ),
        GoRoute(
          path: '/orders',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: BillSummaryScreen(),
          ),
        ),
        GoRoute(
          path: '/account',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AccountScreen(),
          ),
        ),
        GoRoute(
          path: '/order-history',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: OrderHistoryScreen(),
          ),
        ),
        GoRoute(
          path: '/reservations',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TableReservationsScreen(),
          ),
        ),
      ],
    ),
  ],
);
