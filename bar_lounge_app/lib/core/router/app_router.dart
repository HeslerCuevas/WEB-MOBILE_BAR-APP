import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/welcome_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/auth/presentation/confirm_reset_screen.dart';
import '../../features/auth/presentation/verify_code_screen.dart';
import '../../features/auth/presentation/token_action_screen.dart';
import '../../features/scanner/presentation/scanner_screen.dart';
import '../../features/menu/presentation/menu_screen.dart';
import '../../features/orders/presentation/bill_summary_screen.dart';
import '../../features/orders/presentation/order_history_screen.dart';
import '../../features/orders/presentation/order_receipt_screen.dart';
import '../../features/account/presentation/account_screen.dart';
import '../../features/account/presentation/confirm_email_change_code_screen.dart';
import '../../features/account/presentation/account_profile_screen.dart';
import '../../features/account/presentation/change_password_screen.dart';
import '../../features/account/presentation/help_support_screen.dart';
import '../../features/account/presentation/legal_screen.dart';
import '../../features/account/presentation/notification_settings_screen.dart';
import '../../features/account/presentation/security_privacy_screen.dart';

import '../../shared/widgets/bottom_nav_bar.dart';

final _rootNavigatorKey  = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),

    GoRoute(
      path: '/login',
      builder:
          (context, state) => LoginScreen(errorMessage: state.extra as String?),
    ),

    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),

    /// "Forgot password" — user enters their email to receive a reset link.
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),

    /// Password confirm screen — reached via deep-link from the reset email.
    /// nocturnalbar://reset-password?token=<TOKEN>
    /// GoRouter normalises this to /confirm-reset?token=<TOKEN>
    GoRoute(
      path: '/confirm-reset',
      builder: (context, state) => ConfirmResetScreen(
        token: state.uri.queryParameters['token'] ?? '',
      ),
    ),

    GoRoute(
      path: '/verify-code',
      builder: (context, state) {
        final args =
            state.extra as VerifyCodeScreenArgs? ??
            const VerifyCodeScreenArgs(
              purpose: VerifyCodePurpose.emailVerification,
              email: '',
            );
        return VerifyCodeScreen(args: args);
      },
    ),

    GoRoute(
      path: '/order-receipt/:uuid',
      builder:
          (context, state) =>
              OrderReceiptScreen(facturaUuid: state.pathParameters['uuid']!),
    ),

    /// Email change confirmation deep-link
    /// nocturnalbar://confirm-email-change?token=<TOKEN>&tipo=old|new
    GoRoute(
      path: '/confirm-email-change',
      builder: (context, state) => TokenActionScreen(
        token: state.uri.queryParameters['token'] ?? '',
        tipo: state.uri.queryParameters['tipo'],
        action: 'confirm-email-change',
      ),
    ),

    /// Account deletion confirmation deep-link
    /// nocturnalbar://confirm-delete?token=<TOKEN>
    GoRoute(
      path: '/confirm-delete',
      builder: (context, state) => TokenActionScreen(
        token: state.uri.queryParameters['token'] ?? '',
        action: 'confirm-delete',
      ),
    ),

    /// Account reactivation deep-link
    /// nocturnalbar://reactivate?token=<TOKEN>
    GoRoute(
      path: '/reactivate',
      builder: (context, state) => TokenActionScreen(
        token: state.uri.queryParameters['token'] ?? '',
        action: 'reactivate',
      ),
    ),

    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/menu',
          pageBuilder:
              (context, state) => const NoTransitionPage(child: MenuScreen()),
        ),
        GoRoute(
          path: '/scanner',
          pageBuilder:
              (context, state) =>
                  const NoTransitionPage(child: ScannerScreen()),
        ),
        GoRoute(
          path: '/orders',
          pageBuilder:
              (context, state) =>
                  const NoTransitionPage(child: BillSummaryScreen()),
        ),
        GoRoute(
          path: '/account',
          pageBuilder:
              (context, state) =>
                  const NoTransitionPage(child: AccountScreen()),
        ),
        GoRoute(
          path: '/account/change-password',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ChangePasswordScreen()),
        ),
        GoRoute(
          path: '/account/profile',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: AccountProfileScreen()),
        ),
        GoRoute(
          path: '/account/confirm-email-change',
          pageBuilder: (context, state) {
            final args =
                state.extra as ConfirmEmailChangeCodeArgs? ??
                const ConfirmEmailChangeCodeArgs(nuevoEmail: '');
            return NoTransitionPage(
              child: ConfirmEmailChangeCodeScreen(args: args),
            );
          },
        ),
        GoRoute(
          path: '/account/notifications',
          pageBuilder:
              (context, state) =>
                  const NoTransitionPage(child: NotificationSettingsScreen()),
        ),
        GoRoute(
          path: '/account/security',
          pageBuilder:
              (context, state) =>
                  const NoTransitionPage(child: SecurityPrivacyScreen()),
        ),
        GoRoute(
          path: '/account/help',
          pageBuilder:
              (context, state) =>
                  const NoTransitionPage(child: HelpSupportScreen()),
        ),
        GoRoute(
          path: '/legal',
          pageBuilder:
              (context, state) =>
                  const NoTransitionPage(child: LegalScreen()),
        ),
        GoRoute(
          path: '/order-history',
          pageBuilder:
              (context, state) =>
                  const NoTransitionPage(child: OrderHistoryScreen()),
        ),
      ],
    ),
  ],
);
