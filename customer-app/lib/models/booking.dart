class BookingModel {
  final String id;
  final String bookingNumber;
  final String serviceNameSnapshot;
  final String status;
  final DateTime scheduledDate;
  final double? price;
  final String? providerName;
  final String? providerPhone;
  final String? providerAvatar;
  final double? providerRating;
  final int? customerRating;
  final String? customerReview;

  BookingModel({
    required this.id,
    required this.bookingNumber,
    required this.serviceNameSnapshot,
    required this.status,
    required this.scheduledDate,
    this.price,
    this.providerName,
    this.providerPhone,
    this.providerAvatar,
    this.providerRating,
    this.customerRating,
    this.customerReview,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final provider = json['provider_profiles'] ?? json['provider'];
    return BookingModel(
      id: json['id'] ?? '',
      bookingNumber: json['booking_number'] ?? 'WKL-000000',
      serviceNameSnapshot: json['service_name_snapshot'] ?? 'Workla Service',
      status: json['status'] ?? 'requested',
      scheduledDate: DateTime.parse(json['scheduled_date'] ?? json['created_at'] ?? DateTime.now().toIso8601String()),
      price: (json['price'] ?? json['total_amount'] ?? 0.0) as double,
      providerName: provider != null ? provider['full_name'] : null,
      providerPhone: provider != null ? provider['phone'] : null,
      providerAvatar: provider != null ? provider['avatar_url'] : null,
      providerRating: provider != null ? (provider['rating'] ?? 5.0) as double : null,
      customerRating: json['customer_rating'],
      customerReview: json['customer_review'],
    );
  }

  bool get isActive {
    const activeStatuses = ['requested', 'searching', 'confirmed', 'en_route', 'arrived', 'in_progress'];
    return activeStatuses.contains(status);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_number': bookingNumber,
      'service_name_snapshot': serviceNameSnapshot,
      'status': status,
      'scheduled_date': scheduledDate.toIso8601String(),
      'price': price,
      'customer_rating': customerRating,
      'customer_review': customerReview,
    };
  }
}
