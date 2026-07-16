import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import 'cancellation_banner.dart';
class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({super.key, required this.child});
  static const _tabs = [
    _NavTab('/menu', Icons.local_bar, 'LOUNGE'),
    _NavTab('/scanner', Icons.qr_code_scanner, 'SCANNER'),
    _NavTab('/orders', Icons.receipt_long, 'ORDERS'),
    _NavTab('/account', Icons.person, 'ACCOUNT'),
  ];
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _tabs.indexWhere((t) => location.startsWith(t.path));
    final activeIndex = currentIndex == -1 ? 0 : currentIndex;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          if (location.startsWith('/orders'))
            const SafeArea(
              bottom: false,
              child: CancellationBanner(),
            ),
          Expanded(child: child),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow.withValues(alpha: 0.9),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x99000000),
                  blurRadius: 40,
                  offset: Offset(0, -10),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_tabs.length, (i) {
                    final tab = _tabs[i];
                    final isActive = i == activeIndex;
                    return _buildNavItem(
                      context,
                      tab: tab,
                      isActive: isActive,
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildNavItem(
    BuildContext context, {
    required _NavTab tab,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => context.go(tab.path),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surfaceContainerHigh : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 15,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? tab.icon : tab.icon,
              color: isActive
                  ? AppColors.primary
                  : AppColors.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              tab.label,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: isActive
                    ? AppColors.primary
                    : AppColors.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _NavTab {
  final String path;
  final IconData icon;
  final String label;
  const _NavTab(this.path, this.icon, this.label);
}
