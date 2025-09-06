import 'package:flutter_cook_book/data/models/recipe.dart';
import 'package:flutter_cook_book/data/repositories/recipe_repository.dart';
import 'package:flutter_cook_book/di/service_locator.dart';
import 'package:get/get.dart';

class RecipesViewModel extends GetxController {
  final _repository = getIt<RecipeRepository>();

  final RxList<Recipe> _recipes = <Recipe>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;

  Future<void> getRecipes() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      _recipes.value = await _repository.getRecipes();
    } catch (e) {
      _errorMessage.value = 'Falha ao buscar receitas: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }
}
