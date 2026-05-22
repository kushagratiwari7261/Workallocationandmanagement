import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../state/booking_provider.dart';
import '../widgets/bookings/booking_card.dart';
import '../widgets/bookings/cancel_modal.dart';
import '../widgets/bookings/reschedule_modal.dart';
import '../../models/booking.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BookingsTab extends ConsumerStatefulWidget {
  const BookingsTab({super.key});

  @override
  ConsumerState<BookingsTab> createState() => _BookingsTabState();
}

class _BookingsTabState extends ConsumerState<BookingsTab> {
  String _activeFilter = 'all';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(bookingProvider.notifier).fetchBookings();
    });
  }

  void _showCancelSheet(BookingModel booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CancelModal(
        onConfirm: (reason) {
          // Trigger cancellation backend request
        },
      ),
    );
  }

  void _showRescheduleSheet(BookingModel booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RescheduleModal(
        currentScheduledDate: booking.scheduledDate,
        onConfirm: (newDate) {
          // Trigger reschedule backend request
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);

    final filteredList = _activeFilter == 'all'
        ? bookingState.bookings
        : bookingState.bookings.where((b) {
            if (_activeFilter == 'active') return b.isActive;
            return b.status.toLowerCase() == _activeFilter;
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(fontWeight: FontWeight.extrabold, fontSize: 20, color: AppTheme.textMain),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Filter Tabs Horizontal List
          Container(
            height: 50,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('all', 'All'),
                _buildFilterChip('active', 'Active'),
                _buildFilterChip('completed', 'Completed'),
                _buildFilterChip('cancelled', 'Cancelled'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: bookingState.loading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                : filteredList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LucideIcons.calendar, size: 48, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            const Text('No bookings found', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => ref.read(bookingProvider.notifier).fetchBookings(),
                        color: AppTheme.primary,
                        child: ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final booking = filteredList[index];
                            return BookingCard(
                              booking: booking,
                              onCancel: () => _showCancelSheet(booking),
                              onReschedule: () => _showRescheduleSheet(booking),
                              onTrack: () => context.push('/track/${booking.id}'),
                              onRate: () => context.push('/rate/${booking.id}'),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter, String label) {
    final isSelected = _activeFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeFilter = filter;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textMain,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
