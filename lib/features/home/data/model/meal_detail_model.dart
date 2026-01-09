class MealDetailModel {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String image;
  final String youtube;
  final List<Map<String, String>> ingredients;

  const MealDetailModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.image,
    required this.youtube,
    required this.ingredients,
  });

  factory MealDetailModel.fromJson(Map<String, dynamic> json) {
    final List<Map<String, String>> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null &&
          ingredient.toString().isNotEmpty &&
          measure != null &&
          measure.toString().isNotEmpty) {
        ingredients.add({
          'name': ingredient.toString(),
          'measure': measure.toString(),
        });
      }
    }

    return MealDetailModel(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      image: json['strMealThumb'] ?? '',
      youtube: json['strYoutube'] ?? '',
      ingredients: ingredients,
    );
  }
}
