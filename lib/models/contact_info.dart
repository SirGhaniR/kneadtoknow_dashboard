class ContactInfo {
  final int? id;
  final String email;
  final String phone;
  final String address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ContactInfo({
    this.id,
    required this.email,
    required this.phone,
    required this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) => ContactInfo(
    id: json['id'],
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    address: json['address'] ?? '',
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : null,
    updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'])
        : null,
  );
}
