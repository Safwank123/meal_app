import 'package:meal_app/features/home/data/model/favorite_meal_db_model.dart';
import 'package:meal_app/features/home/data/model/meal_detail_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class SQLDatabase {
  static const String _dbName = 'meal_app.db';
  static const int _dbVersion = 2; 
  static Database? _database;


  static Future<Database> get favoritesDb async {
    _database ??= await _openDatabase();
    return _database!;
  }


  static Future<Database> _openDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await FavoriteMealDbModel.createTable(db);
    await MealDetailDbModel.createTable(db);
  }

 
  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await MealDetailDbModel.createTable(db);
    }
  }


  static Future<void> clear() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
