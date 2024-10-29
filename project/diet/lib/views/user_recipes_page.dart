import 'package:flutter/material.dart';
import '../controllers/recipe_controller.dart';
import '../models/recipe.dart';
import 'recipe_detail_page.dart';

class UserRecipesPage extends StatefulWidget {
  final String userId;

  const UserRecipesPage({super.key, required this.userId});

  @override
  _UserRecipesPageState createState() => _UserRecipesPageState();
}

class _UserRecipesPageState extends State<UserRecipesPage> {
  final RecipeController recipeController = RecipeController();
  List<Recipe> userRecipes = [];

  @override
  void initState() {
    super.initState();
    loadUserRecipes();
  }

  Future<void> loadUserRecipes() async {
    final recipes = await recipeController.getUserRecipes(widget.userId);
    setState(() {
      userRecipes = recipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Recetas')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: userRecipes.isEmpty
            ? const Center(child: Text('No tienes recetas creadas.'))
            : ListView.builder(
                itemCount: userRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = userRecipes[index];
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
                      subtitle: Text(recipe.description),
                      trailing: IconButton(
                        icon: Icon(Icons.info_outline, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailPage(recipe: recipe),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
