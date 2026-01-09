import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:meal_app/config/api/api_services.dart';
import 'package:meal_app/config/local/sql_database.dart';
import 'package:meal_app/core/utiles/api_response_handler.dart';

import 'package:meal_app/features/home/data/model/favorite_meal_db_model.dart';
import 'package:meal_app/features/home/data/model/meal_detail_db_model.dart';
import 'package:meal_app/features/home/data/model/meal_detail_model.dart';
import 'package:meal_app/features/home/data/model/meal_model.dart';
import 'package:sqflite/sqflite.dart';

class MealsRepository {
  final ApiServices _apiServices;

  MealsRepository(this._apiServices);


Future<ApiListResponse<MealModel>> fetchAllMeals() async {
  try {
    final connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return ApiListResponse.error(
       
      );
    }

    final json = await _apiServices.getRequest('/search.php?s=');

    if (json != null && json['meals'] != null) {
      final meals = (json['meals'] as List)
          .map((e) => MealModel.fromJson(e))
          .toList();

      return ApiListResponse(
        success: true,
        data: meals,
        count: meals.length,
      );
    }

    return ApiListResponse.error(
      
    );
  } catch (e, s) {
    debugPrint("Fetch meals error: $e");
    debugPrintStack(stackTrace: s);

    return ApiListResponse.error(
    
    );
  }
}



Future<MealDetailModel?> fetchMealDetail(String id) async {
  try {
    final json = await _apiServices.getRequest(
      '/lookup.php',
      queryParams: {'i': id},
    );

    if (json != null && json['meals'] != null) {
      final meal = MealDetailModel.fromJson(json['meals'][0]);
      await saveMealDetail(meal); 
      return meal;
    }
  } catch (_) {

  }

  return await getMealDetailFromDb(id);
}


  Future<List<FavoriteMealDbModel>> getFavorites() async {
    final db = await SQLDatabase.favoritesDb;
    final result = await db.query(FavoriteMealDbModel.tableName);
    return result.map(FavoriteMealDbModel.fromMap).toList();
  }

  Future<bool> isFavorite(String mealId) async {
    final db = await SQLDatabase.favoritesDb;
    final result = await db.query(
      FavoriteMealDbModel.tableName,
      where: 'id = ?',
      whereArgs: [mealId],
    );
    return result.isNotEmpty;
  }

  Future<void> addFavorite(FavoriteMealDbModel meal) async {
    final db = await SQLDatabase.favoritesDb;
    await db.insert(
      FavoriteMealDbModel.tableName,
      meal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String mealId) async {
    final db = await SQLDatabase.favoritesDb;
    await db.delete(
      FavoriteMealDbModel.tableName,
      where: 'id = ?',
      whereArgs: [mealId],
    );
  }

  Future<void> toggleFavorite(FavoriteMealDbModel meal) async {
    final isFav = await isFavorite(meal.id);
    if (isFav) {
      await removeFavorite(meal.id);
    } else {
      await addFavorite(meal);
    }
  }
}

Future<MealDetailModel?> getMealDetailFromDb(String id) async {
  final db = await SQLDatabase.favoritesDb;

  final result = await db.query(
    MealDetailDbModel.tableName,
    where: 'id = ?',
    whereArgs: [id],
  );

  if (result.isEmpty) return null;

  final data = MealDetailDbModel.fromMap(result.first);

  final List ingredientsRaw = jsonDecode(data.ingredientsJson);

  final ingredients = ingredientsRaw
      .map<Map<String, String>>(
        (e) => {
          'name': e['name'].toString(),
          'measure': e['measure'].toString(),
        },
      )
      .toList();

  return MealDetailModel(
    id: data.id,
    name: data.name,
    category: data.category,
    area: data.area,
    instructions: data.instructions,
    image: data.image,
    youtube: data.youtube,
    ingredients: ingredients,
  );
}


Future<void> saveMealDetail(MealDetailModel meal) async {
  final db = await SQLDatabase.favoritesDb;

  final model = MealDetailDbModel(
    id: meal.id,
    name: meal.name,
    category: meal.category,
    area: meal.area,
    instructions: meal.instructions,
    image: meal.image,
    youtube: meal.youtube,
    ingredientsJson: jsonEncode(meal.ingredients),
  );

  await db.insert(
    MealDetailDbModel.tableName,
    model.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
