import 'package:flutter/material.dart';
import '../../models/booking.dart';
import '../../core/theme.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ActiveBookingBanner extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onDismiss;
  final VoidCallback onTap;

  const ActiveBookingBanner({
    super.key,
    required this.booking,
    required this.onDismiss,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Pulse Glowing Circle Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.radio, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                // Text Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Active Booking Status',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.extrabold,
                        ),
                      ),
                      Text(
                        '${booking.serviceNameSnapshot} - ${booking.status.toUpperCase()}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Forward Icon
                const Icon(LucideIcons.chevronRight, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                // Close/Dismiss Button
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onDismiss,
                  icon: const Icon(LucideIcons.x, color: Colors.white70, size: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
