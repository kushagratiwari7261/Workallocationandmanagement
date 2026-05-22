import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refer & Earn', style: TextStyle(fontWeight: FontWeight.extrabold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textMain,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('🎁', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 24),
            const Text(
              'Invite Friends & Earn ₹100',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.extrabold, color: AppTheme.textMain),
            ),
            const SizedBox(height: 8),
            const Text(
              'Share your code with your friends and family. They get ₹100 on their first booking, and you get ₹100 too!',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
              textAlign: Alignment.center,
            ),
            const SizedBox(height: 36),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'WORKLA100',
                    style: TextStyle(fontWeight: FontWeight.extrabold, fontSize: 18, color: AppTheme.primary, letterSpacing: 2),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Code copied to clipboard!'), backgroundColor: AppTheme.primary),
                      );
                    },
                    icon: const Icon(LucideIcons.copy, color: AppTheme.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.share2, size: 20),
              label: const Text('Share Invite Link', style: TextStyle(fontWeight: FontWeight.extrabold)),
            ),
          ],
        ),
      ),
    );
  }
}
