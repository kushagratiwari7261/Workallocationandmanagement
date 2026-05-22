import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../state/auth_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // User Card Profile Header
              Container(
                padding: const EdgeInsets.all(24),
                color: Colors.white,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppTheme.primary.withOpacity(0.1),
                      backgroundImage: user?.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null,
                      child: user?.avatarUrl == null
                          ? const Icon(LucideIcons.user, size: 36, color: AppTheme.primary)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ?? 'Workla Customer',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.extrabold,
                              color: AppTheme.textMain,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? 'customer@workla.com',
                            style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.push('/edit-profile'),
                      icon: const Icon(LucideIcons.edit3, color: AppTheme.primary, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Premium Gold Box Banner
              GestureDetector(
                onTap: () => context.push('/workla-gold'),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Text('👑', style: TextStyle(fontSize: 28)),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Workla Gold',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.extrabold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Enjoy free deliveries and up to 30% discount on all bookings.',
                              style: TextStyle(fontSize: 11, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      Icon(LucideIcons.chevronRight, color: Colors.black87),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Profile Options Grid
              _buildMenuSection([
                _buildMenuItem(LucideIcons.wallet, 'Wallet & Credits', '₹${user?.walletBalance.toStringAsFixed(2) ?? '0.00'}', () => context.push('/wallet')),
                _buildMenuItem(LucideIcons.mapPin, 'Saved Addresses', null, () => context.push('/addresses')),
                _buildMenuItem(LucideIcons.gift, 'Refer & Earn', 'Get ₹100', () => context.push('/referral')),
              ]),
              const SizedBox(height: 12),
              _buildMenuSection([
                _buildMenuItem(LucideIcons.settings, 'Settings', null, () => context.push('/settings')),
                _buildMenuItem(LucideIcons.helpCircle, 'Help & Support', null, () {}),
              ]),
              const SizedBox(height: 16),
              // Sign out Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) context.go('/auth');
                  },
                  icon: const Icon(LucideIcons.logOut, size: 18),
                  label: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String? trailing, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary, size: 20),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textMain),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) ...[
            Text(
              trailing,
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
          ],
          const Icon(LucideIcons.chevronRight, color: AppTheme.textMuted, size: 16),
        ],
      ),
      onTap: onTap,
    );
  }
}
