import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailPage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe
                .imageUrl.isNotEmpty) // Verifica que haya una URL de imagen
              Center(
                child: Image.network(
                  recipe.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 20),
            Text(
              'Autor: ${recipe.authorId}', // Muestra el autor
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Tipo de Receta: ${recipe.recipeType}', // Muestra el tipo de receta
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Descripción:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              recipe.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Ingredientes:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.ingredients.map((ingredient) {
                return Text(
                  '${ingredient.quantity} ${ingredient.unit} de ${ingredient.name}',
                  style: TextStyle(fontSize: 16),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Calorías por gramo: ${recipe.caloriesPerGram}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implementa la función para guardar la receta aquí, si es necesario
              },
              child: Text('Guardar Receta'),
            ),
          ],
        ),
      ),
    );
  }
}
