import 'package:flutter/material.dart';
import '../../models/service.dart';
import '../../core/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeaturedSection extends StatelessWidget {
  final String title;
  final List<ServiceModel> data;
  final bool loading;
  final Function(ServiceModel)? onSelect;

  const FeaturedSection({
    super.key,
    required this.title,
    required this.data,
    required this.loading,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) return const SizedBox.shrink();
    if (data.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.extrabold,
                color: AppTheme.textMain,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16, right: 8),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final service = data[index];
                return GestureDetector(
                  onTap: () {
                    if (onSelect != null) onSelect!(service);
                  },
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12, bottom: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.border, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service Image Thumbnail
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: CachedNetworkImage(
                              imageUrl: service.imageUrl ?? '',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.shade100,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(strokeWidth: 2),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: service.bgColor,
                                alignment: Alignment.center,
                                child: Icon(service.icon, color: service.color, size: 32),
                              ),
                            ),
                          ),
                        ),
                        // Label Details
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.name,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textMain,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                service.description,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.textMuted,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
