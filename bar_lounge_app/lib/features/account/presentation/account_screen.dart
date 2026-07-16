// ignore_for_file: unused_element

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/providers.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  String _avatarStorageKey({required int? clienteId, required String email}) {
    if (clienteId != null) return 'account_avatar_path_$clienteId';
    if (email.isNotEmpty) return 'account_avatar_path_${email.toLowerCase()}';
    return 'account_avatar_path_guest';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeSessionProvider);
    final sessionData = session.maybeWhen(data: (s) => s, orElse: () => null);
    final displayName = session.when(
      data: (s) => s?.nombreDisplay ?? 'Guest',
      loading: () => 'Loading...',
      error: (_, __) => 'Guest',
    );
    final email = session.when(
      data: (s) => s?.email ?? '',
      loading: () => '',
      error: (_, __) => '',
    );
    final isGuest = session.when(
      data: (s) => s?.esInvitado ?? true,
      loading: () => true,
      error: (_, __) => true,
    );
    final avatarStorage = const FlutterSecureStorage();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.amberGlow,
                    ),
                  ),
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: AppColors.background,
                    child: FutureBuilder<String?>(
                      key: ValueKey('${sessionData?.clienteId ?? email}_avatar'),
                      future: avatarStorage.read(
                        key: _avatarStorageKey(
                          clienteId: sessionData?.clienteId,
                          email: email,
                        ),
                      ),
                      builder: (context, snapshot) {
                        final path = snapshot.data;
                        if (path != null && File(path).existsSync()) {
                          return ClipOval(
                            child: Image.file(
                              File(path),
                              width: 104,
                              height: 104,
                              fit: BoxFit.cover,
                            ),
                          );
                        }

                        return Text(
                          displayName.isNotEmpty
                              ? displayName[0].toUpperCase()
                              : 'G',
                          style: GoogleFonts.epilogue(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                displayName,
                style: GoogleFonts.epilogue(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 28),
              if (isGuest) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.glassCardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.lock_person_outlined,
                        size: 40,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Sign in for full access',
                        style: GoogleFonts.epilogue(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Create an account or log in to access loyalty rewards, order history and more.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          color: AppColors.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () => context.push('/login'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryContainer,
                                  foregroundColor: AppColors.onPrimaryContainer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () => context.push('/signup'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.surfaceContainerHigh,
                                  foregroundColor: AppColors.onSurface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                'Quick Actions',
                style: GoogleFonts.epilogue(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => context.push('/order-history'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryContainer.withValues(alpha: 0.7),
                        AppColors.primaryContainer.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.receipt_long,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order History',
                              style: GoogleFonts.epilogue(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.onSurface,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'View your previous rounds and bills',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.primary.withValues(alpha: 0.8),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Settings',
                style: GoogleFonts.epilogue(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 14),
              _settingItem(
                Icons.person_outline,
                'Account Profile',
                onTap: () => context.push('/account/profile'),
              ),
              const SizedBox(height: 8),
              _settingItem(
                Icons.notifications_outlined,
                'Notification Settings',
                onTap: () => context.push('/account/notifications'),
              ),
              const SizedBox(height: 8),
              _settingItem(
                Icons.lock_outline,
                'Security & Privacy',
                onTap: () => context.push('/account/security'),
              ),
              const SizedBox(height: 8),
              _settingItem(
                Icons.help_outline,
                'Help & Support',
                onTap: () => context.push('/account/help'),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (dialogContext) => AlertDialog(
                          backgroundColor: AppColors.surfaceContainerHigh,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(
                            'Leaving the lounge?',
                            style: GoogleFonts.epilogue(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          content: Text(
                            'Are you sure you want to log out?',
                            style: GoogleFonts.manrope(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed:
                                  () => Navigator.of(dialogContext).pop(false),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.manrope(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  () => Navigator.of(dialogContext).pop(true),
                              child: Text(
                                'Logout',
                                style: GoogleFonts.manrope(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                  );
                  if (confirm == true && context.mounted) {
                    await ref.read(carritoDaoProvider).clearCart();
                    await ref.read(mesaDaoProvider).clearAllActiveMesas();
                    await ref.read(sesionDaoProvider).clearSessions();
                    await ref.read(apiClientProvider).clearToken();
                    ref.invalidate(activeSessionProvider);
                    if (context.mounted) context.go('/');
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.error.withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.logout,
                          color: AppColors.error,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Logout',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.error,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'NOCTURNAL APP V1.0.0',
                style: GoogleFonts.manrope(
                  fontSize: 9,
                  letterSpacing: 2,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.35),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickAction(
    BuildContext context,
    IconData icon,
    String label, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${label.replaceAll('\n', ' ')} — coming soon!',
                  style: GoogleFonts.manrope(),
                ),
                backgroundColor: AppColors.surfaceContainerHigh,
                duration: const Duration(seconds: 2),
              ),
            );
          },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingItem(
    IconData icon,
    String label, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surfaceContainerHigh,
              child: Icon(icon, color: AppColors.onSurfaceVariant, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
