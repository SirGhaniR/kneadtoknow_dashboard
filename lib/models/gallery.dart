class Gallery {
  final int id;
  final String title;
  final String? description;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;

  Gallery({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
    id: json['id'],
    title: json['title'] ?? '',
    description: json['description'],
    image: json['image'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );
}
