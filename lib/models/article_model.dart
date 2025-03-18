class Source {
  final String id;
  final String name;

  Source({
    required this.id,
    required this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Source',
    );
  }
}

class Article {
  final String title;
  final String description;
  final String urlToImage;
  final String content;
  final String author;
  final Source source;

  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.content,
    required this.author,
    required this.source,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      urlToImage: json['urlToImage'] ?? '',
      content: json['content'] ?? 'No Content',
      author: json['author'] ?? 'Unknown',
      source: Source.fromJson(json['source'] ?? {'id': '', 'name': 'Unknown Source'}),
    );
  }
}
