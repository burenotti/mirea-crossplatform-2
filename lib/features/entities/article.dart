class Article {
  final int id;
  final String title;
  final String content;
  final DateTime publishedAt;
  final String imageUrl;
  final int readTimeMinutes;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.publishedAt,
    required this.imageUrl,
    required this.readTimeMinutes,
  });

  Article copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? publishedAt,
    String? imageUrl,
    int? readTimeMinutes,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      publishedAt: publishedAt ?? this.publishedAt,
      imageUrl: imageUrl ?? this.imageUrl,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
    );
  }
}
