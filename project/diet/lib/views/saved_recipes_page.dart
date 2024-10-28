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
    setState(() {
      savedRecipes = recipes;
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Imagen de la receta
                          if (recipe.imageUrl.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                recipe.imageUrl,
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(width: 10),
                          // Datos de la receta
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Autor: ${recipe.authorId}'),
                                Text(
                                    'Calorías: ${recipe.caloriesPerGram} kcal/g'),
                              ],
                            ),
                          ),
                          // Botón "Más info"
                          TextButton(
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
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
