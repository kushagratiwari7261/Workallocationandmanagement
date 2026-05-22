import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../state/address_provider.dart';
import '../models/address.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AddressesScreen extends ConsumerStatefulWidget {
  const AddressesScreen({super.key});

  @override
  ConsumerState<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends ConsumerState<AddressesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();
  bool _isDefault = false;

  final List<AddressModel> _mockAddresses = [
    AddressModel(id: 'a1', label: 'Home', name: 'Apartment 4B', address: '123 Main Street, Bangalore', isDefault: true, latitude: 12.9716, longitude: 77.5946),
    AddressModel(id: 'a2', label: 'Work', name: 'Workla Office', address: '456 Tech Park, Whitefield, Bangalore', isDefault: false, latitude: 12.9698, longitude: 77.7499),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(addressProvider.notifier).setSavedAddresses(_mockAddresses);
    });
  }

  void _showAddAddressSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add New Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.extrabold, color: AppTheme.textMain),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(labelText: 'Label (e.g. Home, Office)'),
                validator: (val) => val == null || val.isEmpty ? 'Enter label' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Full Address'),
                validator: (val) => val == null || val.isEmpty ? 'Enter full address' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _landmarkController,
                decoration: const InputDecoration(labelText: 'Landmark (Optional)'),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                title: const Text('Set as Default Address', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                value: _isDefault,
                activeColor: AppTheme.primary,
                onChanged: (val) => setState(() => _isDefault = val ?? false),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  final newAddr = AddressModel(
                    id: DateTime.now().toIso8601String(),
                    label: _labelController.text.trim(),
                    name: '',
                    address: _addressController.text.trim(),
                    landmark: _landmarkController.text.isNotEmpty ? _landmarkController.text.trim() : null,
                    isDefault: _isDefault,
                  );
                  ref.read(addressProvider.notifier).setSavedAddresses([...ref.read(addressProvider).savedAddresses, newAddr]);
                  Navigator.pop(context);
                },
                child: const Text('Add Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Addresses', style: TextStyle(fontWeight: FontWeight.extrabold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textMain,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus, color: AppTheme.primary),
            onPressed: _showAddAddressSheet,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: addressState.savedAddresses.length,
        itemBuilder: (context, index) {
          final addr = addressState.savedAddresses[index];
          final isSelected = addressState.selectedAddress?.id == addr.id;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.border, width: isSelected ? 2 : 1),
            ),
            child: ListTile(
              leading: Icon(LucideIcons.mapPin, color: isSelected ? AppTheme.primary : AppTheme.textMuted),
              title: Row(
                children: [
                  Text(addr.label, style: const TextStyle(fontWeight: FontWeight.extrabold, fontSize: 14, color: AppTheme.textMain)),
                  if (addr.isDefault) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(6)),
                      child: const Text('DEFAULT', style: TextStyle(fontSize: 8, fontWeight: FontWeight.extrabold, color: Colors.green)),
                    ),
                  ],
                ],
              ),
              subtitle: Text(addr.address, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
              onTap: () {
                ref.read(addressProvider.notifier).setSelectedAddress(addr);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }
}
