import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking.dart';
import '../core/api.dart';
import '../core/supabase.dart';

class BookingState {
  final List<BookingModel> bookings;
  final BookingModel? activeBooking;
  final BookingModel? unratedBooking;
  final List<dynamic> drafts;
  final bool loading;
  final String? error;

  BookingState({
    this.bookings = const [],
    this.activeBooking,
    this.unratedBooking,
    this.drafts = const [],
    this.loading = false,
    this.error,
  });

  BookingState copyWith({
    List<BookingModel>? bookings,
    BookingModel? activeBooking,
    BookingModel? unratedBooking,
    List<dynamic>? drafts,
    bool? loading,
    String? error,
  }) {
    return BookingState(
      bookings: bookings ?? this.bookings,
      activeBooking: activeBooking ?? this.activeBooking,
      unratedBooking: unratedBooking ?? this.unratedBooking,
      drafts: drafts ?? this.drafts,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class BookingNotifier extends StateNotifier<BookingState> {
  BookingNotifier() : super(BookingState()) {
    _subscribeToRealtime();
  }

  sb.RealtimeChannel? _realtimeChannel;

  void _subscribeToRealtime() {
    final session = SupabaseService.currentSession;
    if (session?.user == null) return;

    _realtimeChannel = SupabaseService.client
        .channel('public:bookings:customer_${session!.user.id}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'bookings',
          filter: 'customer_id=eq.${session.user.id}',
          callback: (payload) {
            fetchActiveBooking();
            fetchBookings();
          },
        )
        .subscribe();
  }

  Future<void> fetchBookings() async {
    state = state.copyWith(loading: true);
    final response = await ApiClient.get('/api/v1/bookings');
    if (response.error == null && response.data != null) {
      final List rawList = response.data;
      state = state.copyWith(
        bookings: rawList.map((item) => BookingModel.fromJson(item)).toList(),
        loading: false,
      );
    } else {
      state = state.copyWith(loading: false, error: response.error);
    }
  }

  Future<void> fetchActiveBooking() async {
    final response = await ApiClient.get('/api/v1/bookings/active');
    if (response.error == null && response.data != null) {
      state = state.copyWith(
        activeBooking: BookingModel.fromJson(response.data as Map<String, dynamic>),
      );
    } else {
      state = state.copyWith(activeBooking: null);
    }
  }

  Future<void> fetchDrafts() async {
    final response = await ApiClient.get('/api/v1/drafts');
    if (response.error == null && response.data != null) {
      state = state.copyWith(drafts: response.data['data'] ?? []);
    }
  }

  Future<void> clearAllDrafts() async {
    if (state.drafts.isEmpty) return;
    for (final d in state.drafts) {
      await ApiClient.delete('/api/v1/drafts/${d['id']}');
    }
    state = state.copyWith(drafts: []);
  }

  Future<void> dismissActiveBanner() async {
    state = state.copyWith(activeBooking: null);
  }

  @override
  void dispose() {
    if (_realtimeChannel != null) {
      SupabaseService.client.removeChannel(_realtimeChannel!);
    }
    super.dispose();
  }
}

final bookingProvider = StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  return BookingNotifier();
});
