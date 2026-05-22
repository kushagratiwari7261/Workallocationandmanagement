import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'package:lucide_icons/lucide_icons.dart';

class WorklaGoldScreen extends StatefulWidget {
  const WorklaGoldScreen({super.key});

  @override
  State<WorklaGoldScreen> createState() => _WorklaGoldScreenState();
}

class _WorklaGoldScreenState extends State<WorklaGoldScreen> {
  int _selectedPlanIndex = 1;

  final List<Map<String, String>> _plans = [
    {'duration': '1 Month', 'price': '₹199', 'discount': 'Save 0%'},
    {'duration': '3 Months', 'price': '₹499', 'discount': 'Save 16%'},
    {'duration': '12 Months', 'price': '₹1,499', 'discount': 'Save 37%'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workla Gold', style: TextStyle(fontWeight: FontWeight.extrabold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textMain,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gold Header Banner
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  Text('👑', style: TextStyle(fontSize: 48)),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upgrade to Gold',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.extrabold, color: Colors.black87),
                        ),
                        Text(
                          'Get absolute priority on all local logistics requests.',
                          style: TextStyle(color: Colors.black87, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Exclusive Benefits',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.extrabold, color: AppTheme.textMain),
            ),
            const SizedBox(height: 16),
            _buildBenefitItem(LucideIcons.truck, 'Free Delivery', 'Pay zero delivery surcharges on any booking.'),
            _buildBenefitItem(LucideIcons.percent, 'Extra 20% Discount', 'Get automatically applied discounts on checkout.'),
            _buildBenefitItem(LucideIcons.phoneCall, 'Priority Support', 'Skip support queues with direct hotline access.'),
            const SizedBox(height: 32),
            const Text(
              'Select Membership Plan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.extrabold, color: AppTheme.textMain),
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(_plans.length, (index) {
                final plan = _plans[index];
                final isSelected = _selectedPlanIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPlanIndex = index),
                    child: Container(
                      margin: EdgeInsets.only(right: index == _plans.length - 1 ? 0 : 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFFFFDF0) : Colors.white,
                        border: Border.all(color: isSelected ? const Color(0xFFFFB300) : AppTheme.border, width: isSelected ? 2 : 1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(plan['duration']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textMain)),
                          const SizedBox(height: 8),
                          Text(plan['price']!, style: const TextStyle(fontWeight: FontWeight.extrabold, fontSize: 18, color: AppTheme.textMain)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFFFB300).withOpacity(0.15) : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(plan['discount']!, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFFE65100) : AppTheme.textMuted)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 36),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300),
                foregroundColor: Colors.black87,
              ),
              child: const Text('Upgrade to Gold Now', style: TextStyle(fontWeight: FontWeight.extrabold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFFFF8E1),
            radius: 18,
            child: Icon(icon, color: const Color(0xFFFFB300), size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.extrabold, fontSize: 14, color: AppTheme.textMain)),
                Text(desc, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
