import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme.dart';
import '../../state/address_provider.dart';
import '../../state/auth_provider.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(addressProvider);
    final authState = ref.watch(authProvider);
    final selectedAddress = addressState.selectedAddress;

    return Container(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Address Selector
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to addresses page
                  },
                  child: Row(
                    children: [
                      const Icon(LucideIcons.mapPin, color: AppTheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedAddress?.label ?? 'Select Location',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.extrabold,
                                color: AppTheme.textMain,
                              ),
                            ),
                            Text(
                              selectedAddress?.address ?? addressState.rawLocationName,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.chevronDown, color: AppTheme.textMuted, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Loyalty/Notification Items
              Row(
                children: [
                  // Loyalty Coins
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9C4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Text('🪙', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          '${authState.user?.loyaltyCoins ?? 0}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.extrabold,
                            color: Color(0xFFF57F17),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Notification Button
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(LucideIcons.bell, color: AppTheme.textMain, size: 22),
                      ),
                      if ((authState.user?.unreadNotifications ?? 0) > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${authState.user!.unreadNotifications}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: Alignment.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
