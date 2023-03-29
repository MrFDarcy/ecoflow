class Badges {
  final String title;
  final String description;
  final String imageUrl;
  final int range;

  Badges({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.range,
  });

  factory Badges.fromMap(Map<String, dynamic> data) {
    final String? title = data['title'] as String?;
    final String? description = data['description'] as String?;
    final String? imageUrl = data['imageUrl'] as String?;
    final int? range = data['range'] as int?;

    if (title == null ||
        description == null ||
        imageUrl == null ||
        range == null) {
      throw ArgumentError('Invalid data for creating a Badge object: $data');
    }

    return Badges(
      title: title,
      description: description,
      imageUrl: imageUrl,
      range: range,
    );
  }
}
