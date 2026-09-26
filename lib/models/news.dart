class News {
  final int id;
  final String title;
  final String content;
  final String? image;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.isFeatured,
    required this.createdAt,
    required this.updatedAt,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
    id: json['id'],
    title: json['title'] ?? '',
    content: json['content'] ?? '',
    image: json['image'],
    isFeatured: json['is_featured'] == true,
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );
}
