class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final String? phone;
  final String? city;
  final int loyaltyCoins;
  final double walletBalance;
  final int unreadNotifications;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    this.phone,
    this.city,
    required this.loyaltyCoins,
    required this.walletBalance,
    required this.unreadNotifications,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] ?? json;
    return UserModel(
      id: profile['id'] ?? '',
      email: profile['email'] ?? '',
      fullName: profile['full_name'] ?? 'Workla Customer',
      avatarUrl: profile['avatar_url'],
      phone: profile['phone'],
      city: profile['city'],
      loyaltyCoins: profile['loyalty_coins'] ?? 0,
      walletBalance: (profile['wallet_balance'] ?? 0.0) as double,
      unreadNotifications: json['unread_notifications'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'phone': phone,
      'city': city,
      'loyalty_coins': loyaltyCoins,
      'wallet_balance': walletBalance,
    };
  }
}
