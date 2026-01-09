import 'package:sqflite/sqflite.dart';

class FavoriteMealDbModel {
  static const tableName = 'favorite_meals';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id TEXT PRIMARY KEY,
        title TEXT,
        subtitle TEXT,
        imageUrl TEXT
      )
    ''');
  }

  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;

  FavoriteMealDbModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'imageUrl': imageUrl,
      };

  factory FavoriteMealDbModel.fromMap(Map<String, dynamic> map) {
    return FavoriteMealDbModel(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'],
      imageUrl: map['imageUrl'],
    );
  }
}
