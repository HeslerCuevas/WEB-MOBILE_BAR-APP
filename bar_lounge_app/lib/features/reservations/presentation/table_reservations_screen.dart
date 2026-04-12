import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;

import '../../../core/theme/app_colors.dart';
import '../../../data/database/app_database.dart';
import '../../../data/providers/providers.dart';

class TableReservationsScreen extends ConsumerStatefulWidget {
  const TableReservationsScreen({super.key});

  @override
  ConsumerState<TableReservationsScreen> createState() => _TableReservationsScreenState();
}

class _TableReservationsScreenState extends ConsumerState<TableReservationsScreen> {
  DateTime? _selectedDate;
  String _selectedTime = '08:00 PM';
  String _selectedGuests = '2 Guests';
  final _specialRequestsController = TextEditingController();

  final List<String> _timeOptions = [
    '08:00 PM', '08:30 PM', '09:00 PM', '09:30 PM', '10:00 PM', '11:00 PM'
  ];
  final List<String> _guestOptions = [
    '1 Guest', '2 Guests', '3 Guests', '4 Guests', '5 Guests', '6 Guests', 'Large Party'
  ];

  @override
  void dispose() {
    _specialRequestsController.dispose();
    super.dispose();
  }

  Future<void> _submitReservation() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a date', style: GoogleFonts.manrope()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final session = ref.read(activeSessionProvider).maybeWhen(
      data: (s) => s,
      orElse: () => null,
    );
    if (session?.clienteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You must be logged in to make a reservation.', style: GoogleFonts.manrope()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();

    // Insert into db
    await ref.read(reservationsDaoProvider).insertReservation(
      TableReservationsCompanion.insert(
        clienteId: session!.clienteId!,
        venueName: 'The Ember Room', // Hardcoded per UI or we could randomly pick between 'Midnight Lounge' and 'The Ember Room'
        resDate: _selectedDate!,
        resTime: _selectedTime,
        guestsCount: _selectedGuests,
        specialRequests: _specialRequestsController.text.trim().isEmpty ? const drift.Value(null) : drift.Value(_specialRequestsController.text.trim()),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reservation Requested Successfully!', style: GoogleFonts.manrope()),
        backgroundColor: AppColors.primaryContainer,
      ),
    );

    // Reset Form
    setState(() {
      _selectedDate = null;
      _selectedTime = '08:00 PM';
      _selectedGuests = '2 Guests';
      _specialRequestsController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reservationsAsync = ref.watch(userReservationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            backgroundColor: AppColors.background.withValues(alpha: 0.8),
            pinned: true,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/account');
                }
              },
            ),
            title: Text(
              'Table Reservations',
              style: GoogleFonts.epilogue(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -0.5,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Center(
                  child: Text(
                    'NOCTURNAL',
                    style: GoogleFonts.epilogue(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryContainer,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Body ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Upcoming Visits ──
                Row(
                  children: [
                    Container(width: 32, height: 2, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Upcoming Visits',
                      style: GoogleFonts.epilogue(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                reservationsAsync.when(
                  data: (reservations) {
                    if (reservations.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          'You have no upcoming reservations.',
                          style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
                        ),
                      );
                    }
                    return Column(
                      children: reservations.map((res) {
                        return _buildReservationCard(res);
                      }).toList(),
                    );
                  },
                  loading: () => const Center(child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )),
                  error: (e, __) => Text('Error loading reservations', style: TextStyle(color: AppColors.error)),
                ),
                const SizedBox(height: 24),

                // ── Book a Table Header ──
                Text(
                  'Book a Table',
                  style: GoogleFonts.epilogue(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.onSurface, letterSpacing: -0.5),
                ),
                const SizedBox(height: 8),
                Text(
                  'Secure your presence in the sanctuary. Curated experiences await.',
                  style: GoogleFonts.manrope(fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.5),
                ),
                const SizedBox(height: 32),

                // ── Form ──
                // Date
                _buildLabel('Preferred Date'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 60)),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: AppColors.primary,
                              onPrimary: AppColors.onSurface,
                              surface: AppColors.surfaceContainerHigh,
                              onSurface: AppColors.onSurface,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  child: _glassContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate == null ? 'Select date' : DateFormat('MMMM d, yyyy').format(_selectedDate!),
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            color: _selectedDate == null ? AppColors.onSurfaceVariant : AppColors.onSurface,
                          ),
                        ),
                        const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Time and Guests
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Time'),
                          const SizedBox(height: 8),
                          _glassContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedTime,
                                isExpanded: true,
                                icon: const Icon(Icons.schedule, color: AppColors.primary, size: 20),
                                dropdownColor: AppColors.surfaceContainerHigh,
                                style: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: AppColors.onSurface),
                                items: _timeOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                onChanged: (v) => setState(() => _selectedTime = v!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Guests'),
                          const SizedBox(height: 8),
                          _glassContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedGuests,
                                isExpanded: true,
                                icon: const Icon(Icons.person, color: AppColors.primary, size: 20),
                                dropdownColor: AppColors.surfaceContainerHigh,
                                style: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: AppColors.onSurface),
                                items: _guestOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                onChanged: (v) => setState(() => _selectedGuests = v!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Special Requests
                _buildLabel('Special Requests'),
                const SizedBox(height: 8),
                _glassContainer(
                  padding: EdgeInsets.zero,
                  child: TextField(
                    controller: _specialRequestsController,
                    maxLines: 3,
                    style: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: AppColors.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Allergies, celebrations, or seating preferences...',
                      hintStyle: GoogleFonts.manrope(color: AppColors.onSurfaceVariant.withValues(alpha: 0.6)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                GestureDetector(
                  onTap: _submitReservation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: AppColors.amberGlow,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: AppColors.ctaShadow,
                    ),
                    child: Center(
                      child: Text(
                        'REQUEST RESERVATION',
                        style: GoogleFonts.epilogue(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.background,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurfaceVariant,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _glassContainer({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.15)),
      ),
      child: child,
    );
  }

  Widget _buildReservationCard(TableReservation res) {
    final dateObj = res.resDate;
    final isUpcoming = dateObj.isAfter(DateTime.now().subtract(const Duration(days: 1)));
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: isUpcoming ? Border(left: BorderSide(color: AppColors.primaryContainer.withValues(alpha: 0.4), width: 3)) : null,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -10,
            right: -10,
            child: Icon(Icons.event_seat, size: 70, color: AppColors.outlineVariant.withValues(alpha: 0.05)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        res.status.toUpperCase(),
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: res.status == 'Confirmed' ? AppColors.secondary : AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        res.venueName,
                        style: GoogleFonts.epilogue(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.onSurface),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('MMM dd').format(dateObj),
                        style: GoogleFonts.epilogue(fontSize: 18, fontWeight: FontWeight.w800, color: isUpcoming ? AppColors.primary : AppColors.onSurface),
                      ),
                      Text(
                        '${DateFormat('E').format(dateObj)} • ${res.resTime}',
                        style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
                      ),
                      if (isUpcoming) ...[
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            HapticFeedback.lightImpact();
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: AppColors.surfaceContainerHigh,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                title: Text(
                                  'Cancel Reservation', 
                                  style: GoogleFonts.epilogue(color: AppColors.onSurface, fontWeight: FontWeight.w800)
                                ),
                                content: Text(
                                  'Are you sure you want to cancel this reservation?', 
                                  style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, height: 1.5)
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: Text('No', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w700)),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: AppColors.error.withValues(alpha: 0.1),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: Text('Yes, Cancel', style: GoogleFonts.manrope(color: AppColors.error, fontWeight: FontWeight.w800)),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              HapticFeedback.mediumImpact();
                              await ref.read(reservationsDaoProvider).deleteReservation(res.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Reservation successfully cancelled.', style: GoogleFonts.manrope(color: AppColors.background, fontWeight: FontWeight.w700)),
                                    backgroundColor: AppColors.primary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.manrope(
                              fontSize: 12, 
                              fontWeight: FontWeight.w700, 
                              color: AppColors.error,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.error,
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.groups, size: 16, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(res.guestsCount, style: GoogleFonts.manrope(fontSize: 14, color: AppColors.onSurfaceVariant)),
                  const SizedBox(width: 24),
                  if (res.status == 'Confirmed') ...[
                    const Icon(Icons.table_bar, size: 16, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text('Booth Assigned', style: GoogleFonts.manrope(fontSize: 14, color: AppColors.onSurfaceVariant)),
                  ]
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
