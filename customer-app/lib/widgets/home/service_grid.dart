import 'package:flutter/material.dart';
import '../../models/service.dart';
import '../../core/theme.dart';

class ServiceGrid extends StatelessWidget {
  final List<ServiceModel> services;
  final bool loading;
  final String? error;
  final VoidCallback? onRetry;
  final Function(ServiceModel)? onSelect;

  const ServiceGrid({
    super.key,
    required this.services,
    required this.loading,
    this.error,
    this.onRetry,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        height: 180,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: AppTheme.primary),
      );
    }

    if (error != null) {
      return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const Text(
              'Failed to load services',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 8),
            Text(error!, style: TextStyle(color: Colors.red.shade900, fontSize: 12)),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              child: const Text('Try Again', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }

    if (services.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'All Services',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.extrabold, color: AppTheme.textMain),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.78,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return GestureDetector(
                onTap: () {
                  if (onSelect != null) onSelect!(service);
                },
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: service.bgColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        service.icon,
                        color: service.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textMain,
                      ),
                      textAlign: Alignment.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
