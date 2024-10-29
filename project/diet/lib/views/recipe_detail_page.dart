import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/recipe_controller.dart';
import '../models/recipe.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  RecipeDetailPage({required this.recipe});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final RecipeController recipeController = RecipeController();
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    checkIfRecipeIsSaved();
  }

  void checkIfRecipeIsSaved() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      bool saved =
          await recipeController.isRecipeSaved(userId, widget.recipe.id);
      setState(() {
        isSaved = saved;
      });
    }
  }

  void toggleSaveRecipe() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      if (isSaved) {
        await recipeController.removeSavedRecipe(userId, widget.recipe.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Receta quitada de los guardados')),
        );
      } else {
        await recipeController.saveRecipeForUser(userId, widget.recipe);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Receta guardada con éxito')),
        );
      }

      setState(() {
        isSaved = !isSaved;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: No se pudo obtener el ID del usuario')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recipe.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.recipe.imageUrl.isNotEmpty)
              Center(
                child: Image.network(
                  widget.recipe.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 20),
            Text(
              'Autor: ${widget.recipe.authorUsername ?? widget.recipe.authorId}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Tipo de Receta: ${widget.recipe.recipeType}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Descripción:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.recipe.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Ingredientes:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.recipe.ingredients.map((ingredient) {
                return Text(
                  '${ingredient.quantity} ${ingredient.unit} de ${ingredient.name}',
                  style: TextStyle(fontSize: 16),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Calorías por gramo: ${widget.recipe.caloriesPerGram}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: toggleSaveRecipe,
              child: Text(isSaved ? 'Quitar de Guardados' : 'Guardar Receta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSaved ? Colors.red : Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
