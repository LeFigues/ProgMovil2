import 'package:flutter/material.dart';
import '../controllers/recipe_controller.dart';
import '../models/recipe.dart';
import 'recipe_detail_page.dart';

class SavedRecipesPage extends StatefulWidget {
  final String userId;

  const SavedRecipesPage({super.key, required this.userId});

  @override
  _SavedRecipesPageState createState() => _SavedRecipesPageState();
}

class _SavedRecipesPageState extends State<SavedRecipesPage> {
  final RecipeController recipeController = RecipeController();
  List<Recipe> savedRecipes = [];

  @override
  void initState() {
    super.initState();
    loadSavedRecipes();
  }

  Future<void> loadSavedRecipes() async {
    final recipes = await recipeController.getSavedRecipes(widget.userId);
    List<Recipe> updatedRecipes = [];

    for (var recipe in recipes) {
      // Obtén el username del autor usando el ID
      String? username =
          await recipeController.getUsernameById(recipe.authorId);
      updatedRecipes.add(
        Recipe(
          id: recipe.id,
          name: recipe.name,
          authorId: recipe.authorId,
          authorUsername: username, // Asigna el username en lugar del ID
          description: recipe.description,
          ingredients: recipe.ingredients,
          imageUrl: recipe.imageUrl,
          recipeType: recipe.recipeType,
          caloriesPerGram: recipe.caloriesPerGram,
        ),
      );
    }

    setState(() {
      savedRecipes = updatedRecipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recetas Guardadas')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: savedRecipes.isEmpty
            ? const Center(child: Text('No tienes recetas guardadas.'))
            : ListView.builder(
                itemCount: savedRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = savedRecipes[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      leading: recipe.imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                recipe.imageUrl,
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.fastfood,
                              size: 60,
                              color: Colors.grey,
                            ),
                      title: Text(
                        recipe.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Autor: ${recipe.authorUsername ?? recipe.authorId}'),
                          Text('Calorías: ${recipe.caloriesPerGram} kcal/g'),
                        ],
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailPage(recipe: recipe),
                            ),
                          );
                        },
                        child: const Text(
                          'Más info',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
