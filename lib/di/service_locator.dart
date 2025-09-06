import 'package:flutter_cook_book/data/repositories/recipe_repository.dart';
import 'package:flutter_cook_book/data/services/recipe_service.dart';
import 'package:flutter_cook_book/ui/auth/auth_view_model.dart';
import 'package:flutter_cook_book/ui/fav_recipes/fav_recipes_view_model.dart';
import 'package:flutter_cook_book/ui/recipe_detail/recipe_detail_view_model.dart';
import 'package:flutter_cook_book/ui/recipes/recipes_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);
  getIt.registerLazySingleton<RecipeService>(() => RecipeService());
  getIt.registerLazySingleton<RecipeRepository>(() => RecipeRepository());
  getIt.registerLazySingleton<RecipesViewModel>(() => RecipesViewModel());
  getIt.registerLazySingleton<RecipeDetailViewModel>(
    () => RecipeDetailViewModel(),
  );
  getIt.registerLazySingleton<FavRecipesViewModel>(() => FavRecipesViewModel());
  getIt.registerLazySingleton<AuthViewModel>(() => AuthViewModel());
}
