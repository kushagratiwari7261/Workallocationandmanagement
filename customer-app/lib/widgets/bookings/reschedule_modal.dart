import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RescheduleModal extends StatefulWidget {
  final DateTime currentScheduledDate;
  final Function(DateTime) onConfirm;

  const RescheduleModal({
    super.key,
    required this.currentScheduledDate,
    required this.onConfirm,
  });

  @override
  State<RescheduleModal> createState() => _RescheduleModalState();
}

class _RescheduleModalState extends State<RescheduleModal> {
  late DateTime _selectedDate;
  String? _selectedTimeSlot;

  final List<String> _timeSlots = [
    '09:00 AM - 11:00 AM',
    '11:00 AM - 01:00 PM',
    '01:00 PM - 03:00 PM',
    '03:00 PM - 05:00 PM',
    '05:00 PM - 07:00 PM',
    '07:00 PM - 09:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.currentScheduledDate;
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day, _selectedDate.hour, _selectedDate.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reschedule Appointment',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.extrabold,
              color: AppTheme.textMain,
            ),
          ),
          const SizedBox(height: 16),
          // Pick Date Selector Box
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.border),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.calendar, color: AppTheme.primary, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        dateStr,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textMain),
                      ),
                    ],
                  ),
                  const Icon(LucideIcons.edit, color: AppTheme.textMuted, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Select Time Slot',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textMain),
          ),
          const SizedBox(height: 10),
          // Grid of time slots
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _timeSlots.map((slot) {
              final isSelected = _selectedTimeSlot == slot;
              return ChoiceChip(
                label: Text(
                  slot,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textMain,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                selected: isSelected,
                onSelected: (val) {
                  setState(() {
                    _selectedTimeSlot = val ? slot : null;
                  });
                },
                selectedColor: AppTheme.primary,
                backgroundColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: isSelected ? AppTheme.primary : AppTheme.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Back', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectedTimeSlot == null
                      ? null
                      : () {
                          // Extract hour from selected slot, e.g. "09:00 AM - 11:00 AM" -> 9
                          final parts = _selectedTimeSlot!.split(' ');
                          final timeParts = parts[0].split(':');
                          int hour = int.parse(timeParts[0]);
                          final int minute = int.parse(timeParts[1]);
                          final amPm = parts[1];
                          if (amPm == 'PM' && hour < 12) hour += 12;
                          if (amPm == 'AM' && hour == 12) hour = 0;

                          final newDate = DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            _selectedDate.day,
                            hour,
                            minute,
                          );
                          widget.onConfirm(newDate);
                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
