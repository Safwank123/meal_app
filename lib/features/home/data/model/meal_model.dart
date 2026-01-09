class MealModel {
  final String idMeal;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String youtube;

  final List<String> ingredients;
  final List<String> measures;

  const MealModel({
    required this.idMeal,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.youtube,
    required this.ingredients,
    required this.measures,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];
    final measures = <String>[];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add(ingredient.toString());
        measures.add(measure?.toString() ?? '');
      }
    }

    return MealModel(
      idMeal: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      youtube: json['strYoutube'] ?? '',
      ingredients: ingredients,
      measures: measures,
    );
  }

  Map<String, dynamic> toJson() => {
    'idMeal': idMeal,
    'strMeal': name,
    'strCategory': category,
    'strArea': area,
    'strInstructions': instructions,
    'strMealThumb': thumbnail,
    'strYoutube': youtube,
  };
}
