import 'package:flutter/material.dart';
import 'package:flutter_cook_book/di/service_locator.dart';
import 'package:flutter_cook_book/ui/recipes/recipes_view_model.dart';
import 'package:flutter_cook_book/ui/widgets/recipe_card.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class RecipesView extends StatefulWidget {
  const RecipesView({super.key});

  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  final viewModel = getIt<RecipesViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.getRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (viewModel.isLoading) {
        return Center(
          child: SizedBox(
            height: 96,
            width: 96,
            child: CircularProgressIndicator(strokeWidth: 12),
          ),
        );
      }

      if (viewModel.errorMessage != '') {
        return Center(
          child: Container(
            padding: EdgeInsets.all(32),
            child: Column(
              spacing: 32,
              children: [
                Text(
                  'Erro: ${viewModel.errorMessage}',
                  style: TextStyle(fontSize: 24),
                ),
                ElevatedButton(
                  onPressed: () {
                    viewModel.getRecipes();
                  },
                  child: Text('TENTAR NOVAMENTE'),
                ),
              ],
            ),
          ),
        );
      }

      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child:
                  viewModel.recipes.isNotEmpty
                      ? Center(
                        child: Column(
                          children: [
                            Text(
                              '${viewModel.recipes.length} receitas(s)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.builder(
                                itemCount: viewModel.recipes.length,
                                itemBuilder: (context, index) {
                                  final recipe = viewModel.recipes[index];

                                  return Stack(
                                    children: [
                                      GestureDetector(
                                        onTap:
                                            () => context.go(
                                              '/recipe/${recipe.id}',
                                            ),
                                        child: RecipeCard(recipe: recipe),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                      : Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 64),
                            Icon(
                              Icons.favorite,
                              size: 96,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 32),
                            Text(
                              'Adicione suas receitas favoritas!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
            ),
          ],
        ),
      );
    });
  }
}
