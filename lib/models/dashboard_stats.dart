class DashboardStats {
  final int totalNews;
  final int totalGallery;
  final int totalContacts;
  final int unreadContacts;

  DashboardStats({
    required this.totalNews,
    required this.totalGallery,
    required this.totalContacts,
    required this.unreadContacts,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) => DashboardStats(
    totalNews: json['total_news'] ?? 0,
    totalGallery: json['total_gallery'] ?? 0,
    totalContacts: json['total_contacts'] ?? 0,
    unreadContacts: json['unread_contacts'] ?? 0,
  );
}
