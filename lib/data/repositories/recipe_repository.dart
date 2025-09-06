import 'package:flutter_cook_book/data/models/recipe.dart';
import 'package:flutter_cook_book/data/services/recipe_service.dart';
import 'package:flutter_cook_book/di/service_locator.dart';

class RecipeRepository {
  final _service = getIt<RecipeService>();

  Future<List<Recipe>> getRecipes() async {
    try {
      final rawData = await _service.fetchRecipes();
      return rawData.map((data) => Recipe.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Falha ao carregar receitas: ${e.toString()}');
    }
  }
}
