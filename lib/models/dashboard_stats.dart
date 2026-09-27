import 'contact.dart';
import 'news.dart';

class ActivityGroups {
  final List<ActivityItem> news;
  final List<ActivityItem> gallery;
  final List<ActivityItem> contact;

  ActivityGroups({
    required this.news,
    required this.gallery,
    required this.contact,
  });

  factory ActivityGroups.fromJson(Map<String, dynamic> json) => ActivityGroups(
    news: _parse(json['news']),
    gallery: _parse(json['gallery']),
    contact: _parse(json['contact']),
  );

  static List<ActivityItem> _parse(dynamic raw) =>
      (raw as List? ?? []).map((e) => ActivityItem.fromJson(e)).toList();
}

class ActivityItem {
  final DateTime date;
  final int count;

  ActivityItem({required this.date, required this.count});

  factory ActivityItem.fromJson(Map<String, dynamic> json) => ActivityItem(
    date: DateTime.parse(json['date']),
    count: json['count'] ?? 0,
  );
}

class DashboardStats {
  final int totalNews;
  final int totalGallery;
  final int totalContacts;
  final int unreadContacts;
  final ActivityGroups activity;
  final List<News> recentNews;
  final List<Contact> recentContacts;
  final List<News> featuredNews;

  DashboardStats({
    required this.totalNews,
    required this.totalGallery,
    required this.totalContacts,
    required this.unreadContacts,
    required this.activity,
    required this.recentNews,
    required this.recentContacts,
    required this.featuredNews,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) => DashboardStats(
    totalNews: json['total_news'] ?? 0,
    totalGallery: json['total_gallery'] ?? 0,
    totalContacts: json['total_contacts'] ?? 0,
    unreadContacts: json['unread_contacts'] ?? 0,
    activity: ActivityGroups.fromJson(json['activity'] ?? {}),
    recentNews: (json['recent_news'] as List? ?? [])
        .map((e) => News.fromJson(e))
        .toList(),
    recentContacts: (json['recent_contacts'] as List? ?? [])
        .map((e) => Contact.fromJson(e))
        .toList(),
    featuredNews: (json['featured_news'] as List? ?? [])
        .map((e) => News.fromJson(e))
        .toList(),
  );
}
