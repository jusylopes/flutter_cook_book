import 'package:flutter_cook_book/data/models/recipe.dart';
import 'package:flutter_cook_book/data/repositories/auth_repository.dart';
import 'package:flutter_cook_book/data/repositories/recipe_repository.dart';
import 'package:flutter_cook_book/di/service_locator.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FavRecipesViewModel extends GetxController {
  final _repository = getIt<RecipeRepository>();
  final _authRepository = getIt<AuthRepository>();

  final RxList<Recipe> _favRecipes = <Recipe>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  List<Recipe> get favRecipes => _favRecipes;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;

  Future<void> getFavRecipes() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      var userId = '';
      (await _authRepository.currentUser).fold(
        (left) => _errorMessage.value = left.message,
        (right) => userId = right.id,
      );

      _favRecipes.value = await _repository.getFavRecipes(userId);
    } catch (e) {
      _errorMessage.value = 'Falha ao buscar receitas: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }
}
