import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../state/address_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BookingWorkflowScreen extends ConsumerStatefulWidget {
  final String serviceId;

  const BookingWorkflowScreen({super.key, required this.serviceId});

  @override
  ConsumerState<BookingWorkflowScreen> createState() => _BookingWorkflowScreenState();
}

class _BookingWorkflowScreenState extends ConsumerState<BookingWorkflowScreen> {
  int _currentStep = 1;
  final int _totalSteps = 3;

  String? _selectedSubcategory;
  String? _selectedSlot;

  final List<String> _subcategories = [
    'Deep Kitchen Cleaning',
    'Full Home Dusting',
    'Sofa & Carpet Vacuum',
    'Window & Balcony Wash',
  ];

  final List<String> _slots = [
    'Morning (09:00 AM - 12:00 PM)',
    'Afternoon (12:00 PM - 03:00 PM)',
    'Evening (03:00 PM - 06:00 PM)',
    'Late Evening (06:00 PM - 09:00 PM)',
  ];

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
      });
    } else {
      _checkout();
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _checkout() async {
    // Mimic the Razorpay trigger and final booking order placement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          margin: EdgeInsets.all(24),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppTheme.primary),
                SizedBox(height: 16),
                Text('Placing Booking Request...', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pop(context); // Pop loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Book Service', style: TextStyle(fontWeight: FontWeight.extrabold, fontSize: 16)),
            Text('Step $_currentStep of $_totalSteps', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppTheme.textMain,
      ),
      body: Column(
        children: [
          // Custom progress indicator bar
          LinearProgressIndicator(
            value: _currentStep / _totalSteps,
            backgroundColor: Colors.grey.shade100,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
            minHeight: 4,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildCurrentStepContent(addressState),
            ),
          ),
          // Footer Actions Panel
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppTheme.border)),
            ),
            child: Row(
              children: [
                if (_currentStep > 1) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _prevStep,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Back', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canProceed(addressState) ? _nextStep : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(_currentStep == _totalSteps ? 'Place Order' : 'Continue'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed(AddressState addressState) {
    if (_currentStep == 1) return _selectedSubcategory != null;
    if (_currentStep == 2) return addressState.selectedAddress != null && _selectedSlot != null;
    return true; // checkout step
  }

  Widget _buildCurrentStepContent(AddressState addressState) {
    switch (_currentStep) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Subcategory',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.extrabold, color: AppTheme.textMain),
            ),
            const SizedBox(height: 6),
            const Text('Choose the exact service scope you need.', style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
            const SizedBox(height: 20),
            ..._subcategories.map((sub) {
              final isSel = _selectedSubcategory == sub;
              return GestureDetector(
                onTap: () => setState(() => _selectedSubcategory = sub),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSel ? AppTheme.primary.withOpacity(0.04) : Colors.white,
                    border: Border.all(color: isSel ? AppTheme.primary : AppTheme.border, width: isSel ? 2 : 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(sub, style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textMain)),
                      Icon(
                        isSel ? LucideIcons.checkCircle : LucideIcons.circle,
                        color: isSel ? AppTheme.primary : AppTheme.textMuted,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Location & Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.extrabold, color: AppTheme.textMain),
            ),
            const SizedBox(height: 20),
            // Selected Address Display
            const Text('Delivery Address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.mapPin, color: AppTheme.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      addressState.selectedAddress?.address ?? 'No address selected. Please select one.',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textMain),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Available Time Slots', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
            const SizedBox(height: 10),
            ..._slots.map((slot) {
              final isSel = _selectedSlot == slot;
              return GestureDetector(
                onTap: () => setState(() => _selectedSlot = slot),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSel ? AppTheme.primary.withOpacity(0.04) : Colors.white,
                    border: Border.all(color: isSel ? AppTheme.primary : AppTheme.border, width: isSel ? 2 : 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(slot, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textMain)),
                      Icon(
                        isSel ? LucideIcons.check : LucideIcons.circle,
                        color: isSel ? AppTheme.primary : AppTheme.textMuted,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      case 3:
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Checkout Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.extrabold, color: AppTheme.textMain),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.border),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Service', _selectedSubcategory ?? ''),
                  const Divider(height: 24),
                  _buildSummaryRow('Scheduled Time', _selectedSlot ?? ''),
                  const Divider(height: 24),
                  _buildSummaryRow('Standard Fare', '₹499.00'),
                  _buildSummaryRow('GST (18%)', '₹89.82'),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.extrabold, fontSize: 15, color: AppTheme.textMain)),
                      Text('₹588.82', style: TextStyle(fontWeight: FontWeight.extrabold, fontSize: 16, color: AppTheme.primary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.w600, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.textMain)),
        ],
      ),
    );
  }
}
