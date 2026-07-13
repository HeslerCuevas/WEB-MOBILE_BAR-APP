import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class CancellationState {
  /// UUID of the order currently in the cancellation window.
  final String? facturaUuid;

  /// Snapshot of the cart items at the moment the order was placed,
  /// used to restore the cart if the user cancels.
  final List<CarritoLocalData> cartSnapshot;

  /// Remaining seconds (0‥90). 0 means the window has expired.
  final int secondsLeft;

  /// True while the countdown is running (> 0 seconds left).
  final bool isActive;

  const CancellationState({
    this.facturaUuid,
    this.cartSnapshot = const [],
    this.secondsLeft = 0,
    this.isActive = false,
  });

  CancellationState copyWith({
    String? facturaUuid,
    List<CarritoLocalData>? cartSnapshot,
    int? secondsLeft,
    bool? isActive,
  }) {
    return CancellationState(
      facturaUuid: facturaUuid ?? this.facturaUuid,
      cartSnapshot: cartSnapshot ?? this.cartSnapshot,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Human-readable countdown string (MM:SS).
  String get formattedTime {
    final m = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class CancellationNotifier extends StateNotifier<CancellationState> {
  static const _kWindowSeconds = 90;

  Timer? _timer;

  CancellationNotifier() : super(const CancellationState());

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Starts a 90-second cancellation window for [facturaUuid].
  /// [cartSnapshot] is the list of cart items just submitted — kept so
  /// the user can restore them if they cancel.
  ///
  /// If a timer is already running it is cancelled first, ensuring only
  /// one window exists at a time.
  void startTimer(String facturaUuid, List<CarritoLocalData> cartSnapshot) {
    _cancelTimer();

    state = CancellationState(
      facturaUuid: facturaUuid,
      cartSnapshot: List.unmodifiable(cartSnapshot),
      secondsLeft: _kWindowSeconds,
      isActive: true,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  /// Stops the countdown and hides the banner (e.g. after payment requested,
  /// successful cancellation, or FCM payment confirmed).
  void stopTimer() {
    _cancelTimer();
    state = const CancellationState();
  }

  // ── Internal ───────────────────────────────────────────────────────────────

  void _tick() {
    final remaining = state.secondsLeft - 1;
    if (remaining <= 0) {
      // Time's up — hide banner, order proceeds normally.
      _cancelTimer();
      state = const CancellationState();
    } else {
      state = state.copyWith(secondsLeft: remaining);
    }
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final cancellationProvider =
    StateNotifierProvider<CancellationNotifier, CancellationState>(
  (ref) => CancellationNotifier(),
);
