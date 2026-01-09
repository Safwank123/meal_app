import 'package:sqflite/sqflite.dart';

class MealDetailDbModel {
  static const tableName = 'meal_details';

  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String image;
  final String youtube;
  final String ingredientsJson;

  MealDetailDbModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.image,
    required this.youtube,
    required this.ingredientsJson,
  });

 
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'area': area,
        'instructions': instructions,
        'image': image,
        'youtube': youtube,
        'ingredients': ingredientsJson,
      };

  
  factory MealDetailDbModel.fromMap(Map<String, dynamic> map) {
    return MealDetailDbModel(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      area: map['area'],
      instructions: map['instructions'],
      image: map['image'],
      youtube: map['youtube'],
      ingredientsJson: map['ingredients'],
    );
  }

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id TEXT PRIMARY KEY,
        name TEXT,
        category TEXT,
        area TEXT,
        instructions TEXT,
        image TEXT,
        youtube TEXT,
        ingredients TEXT
      )
    ''');
  }
}
