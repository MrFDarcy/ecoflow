import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id = '';
  String caption = '';
  String? description = '';
  String imageUrl = '';
  Timestamp timestamp = Timestamp.now();
  String userId = '';

  Post({
    this.id,
    required this.caption,
    this.description,
    required this.imageUrl,
    required this.timestamp,
    required this.userId,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      caption: data['caption'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'caption': caption,
      'description': description,
      'imageUrl': imageUrl,
      'timestamp': timestamp, // use the timestamp field of the object
      'userId': userId,
    };
  }

  factory Post.fromMap(Map<String, dynamic> data, String id) {
    if (data == null) {
      return Post(
        id: id,
        caption: '',
        description: '',
        imageUrl: '',
        timestamp: Timestamp.now(),
        userId: '',
      );
    }
    final String caption = data['caption'] ?? '';
    final String description = data['description'] ?? '';
    final String imageUrl = data['imageUrl'] ?? '';
    final Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
    final String userId = data['userId'] ?? '';

    return Post(
      id: id,
      caption: caption,
      description: description,
      imageUrl: imageUrl,
      timestamp: timestamp,
      userId: userId,
    );
  }
}
