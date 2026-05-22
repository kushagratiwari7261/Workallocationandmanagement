import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../state/address_provider.dart';
import '../state/booking_provider.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/offers_carousel.dart';
import '../widgets/home/service_grid.dart';
import '../widgets/home/featured_section.dart';
import '../widgets/home/active_booking_banner.dart';
import '../../models/service.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  bool _loading = true;
  List<ServiceModel> _services = [];
  List<dynamic> _banners = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    ref.read(addressProvider.notifier).requestLocationAndDetect();
    ref.read(bookingProvider.notifier).fetchActiveBooking();
    ref.read(bookingProvider.notifier).fetchDrafts();

    // Emulate services loading
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _services = [
          ServiceModel(id: '1', name: 'Cleaning Services', slug: 'cleaning', description: 'Deep home and office cleaning', displayOrder: 1, priorityNumber: 1),
          ServiceModel(id: '2', name: 'Plumbing Repair', slug: 'plumbing', description: 'Leaking pipe repairs and setups', displayOrder: 2, priorityNumber: 2),
          ServiceModel(id: '3', name: 'Electrician Services', slug: 'electrician', description: 'Fault diagnosis and fan repairs', displayOrder: 3, priorityNumber: 3),
          ServiceModel(id: '4', name: 'AC Maintenance', slug: 'ac-service', description: 'Air filter cleaning and refilling', displayOrder: 4, priorityNumber: 4),
          ServiceModel(id: '5', name: 'Pest Control', slug: 'pest-control', description: 'Safe organic bug treatments', displayOrder: 5, priorityNumber: 5),
          ServiceModel(id: '6', name: 'Appliance Care', slug: 'appliance-repair', description: 'Oven and fridge mechanics', displayOrder: 6, priorityNumber: 6),
          ServiceModel(id: '7', name: 'Home Paint jobs', slug: 'paint', description: 'Full flat custom repainting', displayOrder: 7, priorityNumber: 7),
        ];
        _banners = [
          {'image_url': 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800'},
          {'image_url': 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=800'},
        ];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);

    return Scaffold(
      body: Column(
        children: [
          const HomeHeader(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadInitialData,
              color: AppTheme.primary,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Active Booking Alert Banner
                  if (bookingState.activeBooking != null)
                    ActiveBookingBanner(
                      booking: bookingState.activeBooking!,
                      onDismiss: () => ref.read(bookingProvider.notifier).dismissActiveBanner(),
                      onTap: () => context.push('/track/${bookingState.activeBooking!.id}'),
                    ),

                  OffersCarousel(banners: _banners, loading: _loading),

                  // Continuation of drafts card
                  if (bookingState.drafts.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Continue Booking',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.extrabold, color: AppTheme.textMain),
                          ),
                          TextButton(
                            onPressed: () => ref.read(bookingProvider.notifier).clearAllDrafts(),
                            child: const Text('Clear All', style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        itemCount: bookingState.drafts.length,
                        itemBuilder: (context, index) {
                          final draft = bookingState.drafts[index];
                          return GestureDetector(
                            onTap: () => context.push('/book/${draft['service_id']}?resume=true&draftId=${draft['id']}'),
                            child: Container(
                              width: 240,
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppTheme.border),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppTheme.primary.withOpacity(0.1),
                                    radius: 20,
                                    child: const Text('📝', style: TextStyle(fontSize: 16)),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          draft['service_subcategories']?['name'] ?? 'Incomplete Booking',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textMain),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Step ${draft['current_step']} of ${draft['total_steps']}',
                                          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  ServiceGrid(
                    services: _services,
                    loading: _loading,
                    onSelect: (srv) => context.push('/book/${srv.id}'),
                  ),

                  FeaturedSection(
                    title: '⭐ Popular Services',
                    data: _services.take(3).toList(),
                    loading: _loading,
                    onSelect: (srv) => context.push('/book/${srv.id}'),
                  ),

                  FeaturedSection(
                    title: '⚡ Smart Picks',
                    data: _services.skip(3).take(3).toList(),
                    loading: _loading,
                    onSelect: (srv) => context.push('/book/${srv.id}'),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
