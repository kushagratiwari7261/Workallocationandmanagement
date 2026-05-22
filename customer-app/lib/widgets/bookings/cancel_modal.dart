import 'package:flutter/material.dart';
import '../../core/theme.dart';

class CancelModal extends StatefulWidget {
  final Function(String) onConfirm;

  const CancelModal({super.key, required this.onConfirm});

  @override
  State<CancelModal> createState() => _CancelModalState();
}

class _CancelModalState extends State<CancelModal> {
  final List<String> _reasons = [
    'Plan changed / No longer needed',
    'Provider did not show up on time',
    'Found a cheaper alternative elsewhere',
    'Accidentally placed booking',
    'Other reason / Custom query',
  ];
  String? _selectedReason;
  final TextEditingController _customController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cancel Booking?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.extrabold,
              color: AppTheme.textMain,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Please select a reason to help us improve.',
            style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 16),
          ..._reasons.map((reason) {
            return RadioListTile<String>(
              title: Text(
                reason,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textMain),
              ),
              value: reason,
              groupValue: _selectedReason,
              activeColor: Colors.red,
              onChanged: (val) {
                setState(() {
                  _selectedReason = val;
                });
              },
              contentPadding: EdgeInsets.zero,
            );
          }),
          if (_selectedReason == 'Other reason / Custom query') ...[
            const SizedBox(height: 8),
            TextField(
              controller: _customController,
              decoration: const InputDecoration(
                hintText: 'Describe details...',
              ),
              maxLines: 2,
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Keep Booking', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectedReason == null
                      ? null
                      : () {
                          final finalReason = _selectedReason == 'Other reason / Custom query'
                              ? _customController.text
                              : _selectedReason!;
                          widget.onConfirm(finalReason);
                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Cancel Booking', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }
}
