import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme.dart';

class ServiceModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String? imageUrl;
  final int displayOrder;
  final int priorityNumber;

  ServiceModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    this.imageUrl,
    required this.displayOrder,
    required this.priorityNumber,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? 'home',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      displayOrder: json['display_order'] ?? 0,
      priorityNumber: json['priority_number'] ?? json['display_order'] ?? 0,
    );
  }

  IconData get icon {
    switch (slug) {
      case 'cleaning': return LucideIcons.sprout;
      case 'plumbing': return LucideIcons.wrench;
      case 'electrician': return LucideIcons.zap;
      case 'ac-service': return LucideIcons.snowflake;
      case 'pest-control': return LucideIcons.shield;
      case 'appliance-repair': return LucideIcons.hammer;
      case 'paint': return LucideIcons.paintbrush;
      default: return LucideIcons.grid;
    }
  }

  Color get color => AppTheme.getColorForCategory(slug);
  Color get bgColor => AppTheme.getBgForCategory(slug);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'image_url': imageUrl,
      'display_order': displayOrder,
      'priority_number': priorityNumber,
    };
  }
}
