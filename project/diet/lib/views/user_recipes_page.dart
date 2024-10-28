import 'package:flutter/material.dart';
import '../controllers/recipe_controller.dart';
import '../models/recipe.dart';

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
      body: ListView.builder(
        itemCount: userRecipes.length,
        itemBuilder: (context, index) {
          final recipe = userRecipes[index];
          return ListTile(
            title: Text(recipe.name),
            subtitle: Text(recipe.description),
          );
        },
      ),
    );
  }
}
