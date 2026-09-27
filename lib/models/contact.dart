class Contact {
  final int id;
  final String name;
  final String email;
  final String subject;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  Contact({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    id: json['id'],
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    subject: json['subject'] ?? '',
    message: json['message'] ?? '',
    isRead: json['is_read'] == true,
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );
}
