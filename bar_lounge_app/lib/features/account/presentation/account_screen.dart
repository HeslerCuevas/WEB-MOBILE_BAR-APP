import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/providers.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeSessionProvider);
    final displayName = session.when(
      data: (s) => s?.nombreDisplay ?? 'Guest',
      loading: () => 'Loading...',
      error: (_, __) => 'Guest',
    );
    final isGuest = session.when(
      data: (s) => s?.esInvitado ?? true,
      loading: () => true,
      error: (_, __) => true,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
          child: Column(children: [
            const SizedBox(height: 16),
            // ── Avatar ──
            Stack(alignment: Alignment.center, children: [
              Container(
                width: 110, height: 110,
                decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppColors.amberGlow),
              ),
              CircleAvatar(
                radius: 52,
                backgroundColor: AppColors.background,
                child: Text(
                  displayName.isNotEmpty ? displayName[0].toUpperCase() : 'G',
                  style: GoogleFonts.epilogue(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.primary),
                ),
              ),
            ]),
            const SizedBox(height: 14),
            Text(displayName, style: GoogleFonts.epilogue(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.onSurface)),
            const SizedBox(height: 28),
            // If guest, show login prompt
            if (isGuest) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.glassCardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                ),
                child: Column(children: [
                  const Icon(Icons.lock_person_outlined, size: 40, color: AppColors.primary),
                  const SizedBox(height: 12),
                  Text('Sign in for full access', style: GoogleFonts.epilogue(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                  const SizedBox(height: 6),
                  Text('Create an account or log in to access loyalty rewards, order history and more.',
                      textAlign: TextAlign.center, style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.4)),
                  const SizedBox(height: 20),
                  Row(children: [
                    Expanded(child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => context.push('/login'),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryContainer, foregroundColor: AppColors.onPrimaryContainer, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        child: Text('Login', style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
                      ),
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => context.push('/signup'),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.surfaceContainerHigh, foregroundColor: AppColors.onSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        child: Text('Sign Up', style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
                      ),
                    )),
                  ]),
                ]),
              ),
            ],
            const SizedBox(height: 16),
            // ── Quick Actions Grid ──
            Text('Quick Actions', style: GoogleFonts.epilogue(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant.withValues(alpha: 0.8))),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1.3,
                    child: _quickAction(context, Icons.receipt_long, 'Order\nHistory', onTap: () => context.push('/order-history')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1.3,
                    child: _quickAction(context, Icons.event_seat, 'Table\nReservations', onTap: () => context.push('/reservations')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            // ── Settings ──
            Text('Settings', style: GoogleFonts.epilogue(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant.withValues(alpha: 0.8))),
            const SizedBox(height: 14),
            _settingItem(Icons.notifications_outlined, 'Notification Settings', onTap: () {}),
            const SizedBox(height: 8),
            _settingItem(Icons.lock_outline, 'Security & Privacy', onTap: () {}),
            const SizedBox(height: 8),
            _settingItem(Icons.help_outline, 'Help & Support', onTap: () {}),
            const SizedBox(height: 8),
            // ── Logout ──
            GestureDetector(
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    backgroundColor: AppColors.surfaceContainerHigh,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: Text('Leaving the lounge?', style: GoogleFonts.epilogue(fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                    content: Text('Are you sure you want to log out?', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant)),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(dialogContext).pop(false),
                          child: Text('Cancel', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant))),
                      TextButton(onPressed: () => Navigator.of(dialogContext).pop(true),
                          child: Text('Logout', style: GoogleFonts.manrope(color: AppColors.error, fontWeight: FontWeight.w700))),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  
                  // Clear cart so the next user starts fresh
                  await ref.read(carritoDaoProvider).clearCart();
                  await ref.read(mesaDaoProvider).clearAllActiveMesas();
                  await ref.read(sesionDaoProvider).clearSessions();
                  await ref.read(apiClientProvider).clearToken();
                  if (context.mounted) context.go('/');
                }
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  CircleAvatar(radius: 18, backgroundColor: AppColors.error.withValues(alpha: 0.1),
                      child: const Icon(Icons.logout, color: AppColors.error, size: 18)),
                  const SizedBox(width: 14),
                  Text('Logout', style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.error)),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: AppColors.error, size: 18),
                ]),
              ),
            ),
            const SizedBox(height: 24),
            Text('NOCTURNAL APP V1.0.0', style: GoogleFonts.manrope(fontSize: 9, letterSpacing: 2, color: AppColors.onSurfaceVariant.withValues(alpha: 0.35))),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
  }

  Widget _quickAction(BuildContext context, IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${label.replaceAll('\n', ' ')} — coming soon!',
              style: GoogleFonts.manrope()), backgroundColor: AppColors.surfaceContainerHigh, duration: const Duration(seconds: 2)),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: 10),
            Text(label, textAlign: TextAlign.center, style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.onSurface, height: 1.1)),
          ]
        ),
      ),
    );
  }

  Widget _settingItem(IconData icon, String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          CircleAvatar(radius: 18, backgroundColor: AppColors.surfaceContainerHigh,
              child: Icon(icon, color: AppColors.onSurfaceVariant, size: 18)),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.onSurface))),
          const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant, size: 16),
        ]),
      ),
    );
  }
}
