import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/services/notification_service.dart';
import 'widgets/account_page_scaffold.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _orderUpdates = true;
  bool _specialEvents = true;
  bool _accountSecurity = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final orderUpdates = await NotificationService.areOrderUpdatesEnabled();
    final specialEvents = await NotificationService.areSpecialEventsEnabled();
    final accountSecurity = await NotificationService.isAccountSecurityEnabled();
    if (!mounted) return;
    setState(() {
      _orderUpdates = orderUpdates;
      _specialEvents = specialEvents;
      _accountSecurity = accountSecurity;
      _loading = false;
    });
  }

  Future<void> _setOrderUpdates(bool value) async {
    setState(() => _orderUpdates = value);
    await NotificationService.setOrderUpdatesEnabled(value);
    if (value) {
      await NotificationService.initialize();
    }
  }

  Future<void> _setSpecialEvents(bool value) async {
    setState(() => _specialEvents = value);
    await NotificationService.setSpecialEventsEnabled(value);
    if (value) {
      await NotificationService.initialize();
    }
  }

  Future<void> _setAccountSecurity(bool value) async {
    setState(() => _accountSecurity = value);
    await NotificationService.setAccountSecurityEnabled(value);
    if (value) {
      await NotificationService.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AccountPageScaffold(
      title: 'Notifications',
      brandText: normalizeBrandText(),
      children: [
        Text(
          'Manage how Nocturnal communicates with you.',
          style: GoogleFonts.manrope(
            fontSize: 13,
            color: AppColors.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 28),
        if (_loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          )
        else ...[
          _notificationTile(
            title: 'Order Updates',
            description: 'Real-time status of your drinks and bottle service.',
            value: _orderUpdates,
            onChanged: _setOrderUpdates,
          ),
          const SizedBox(height: 16),
          _notificationTile(
            title: 'Special Events',
            description: 'Invites to exclusive guest DJs and private rooms.',
            value: _specialEvents,
            onChanged: _setSpecialEvents,
          ),
          const SizedBox(height: 16),
          _notificationTile(
            title: 'Account Security',
            description: 'Important alerts regarding login activity.',
            value: _accountSecurity,
            onChanged: _setAccountSecurity,
          ),
        ],
      ],
    );
  }

  Widget _notificationTile({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return AccountGlassCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.epilogue(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    height: 1.4,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.primaryContainer,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.surfaceContainerHighest,
          ),
        ],
      ),
    );
  }
}
