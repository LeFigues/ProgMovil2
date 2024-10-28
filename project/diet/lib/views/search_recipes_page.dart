import 'package:flutter/material.dart';
import '../controllers/recipe_controller.dart';
import '../models/recipe.dart';
import 'recipe_detail_page.dart';

class SearchRecipesPage extends StatefulWidget {
  const SearchRecipesPage({super.key});

  @override
  _SearchRecipesPageState createState() => _SearchRecipesPageState();
}

class _SearchRecipesPageState extends State<SearchRecipesPage> {
  final RecipeController recipeController = RecipeController();
  final TextEditingController searchController = TextEditingController();
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    loadAllRecipes(); // Carga todas las recetas al inicio
  }

  Future<void> loadAllRecipes() async {
    final results = await recipeController.getRecipes();
    setState(() {
      recipes = results;
    });
  }

  void searchRecipes(String query) {
    // Filtra recetas por el término de búsqueda
    final filteredRecipes = recipes.where((recipe) {
      return recipe.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      recipes = filteredRecipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Recetas')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: searchRecipes,
              decoration: InputDecoration(
                labelText: 'Buscar receta',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
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
                          // Botón "Mostrar más"
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
          ],
        ),
      ),
    );
  }
}
