import 'package:diet/models/ingredient.dart';

class Recipe {
  final String id;
  final String name;
  final String authorId;
  final String description;
  final List<Ingredient> ingredients;
  final String imageUrl; // URL de la imagen en Storage
  final String recipeType; // Tipo de receta (ej: Vegano, Vegetariano)
  final double caloriesPerGram; // Calorías por gramo

  Recipe({
    required this.id,
    required this.name,
    required this.authorId,
    required this.description,
    required this.ingredients,
    required this.imageUrl,
    required this.recipeType,
    required this.caloriesPerGram,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'authorId': authorId,
      'description': description,
      'ingredients':
          ingredients.map((ingredient) => ingredient.toMap()).toList(),
      'imageUrl': imageUrl, // Almacena la URL de la imagen
      'recipeType': recipeType, // Almacena el tipo de receta
      'caloriesPerGram': caloriesPerGram, // Almacena las calorías por gramo
    };
  }

  factory Recipe.fromMap(String id, Map<String, dynamic> data) {
    List<dynamic> ingredientMaps = data['ingredients'] ?? [];
    List<Ingredient> ingredients =
        ingredientMaps.map((map) => Ingredient.fromMap(map)).toList();

    return Recipe(
      id: id,
      name: data['name'],
      authorId: data['authorId'],
      description: data['description'],
      ingredients: ingredients,
      imageUrl: data['imageUrl'], // Extrae la URL de la imagen
      recipeType: data['recipeType'], // Extrae el tipo de receta
      caloriesPerGram:
          data['caloriesPerGram'].toDouble(), // Extrae las calorías por gramo
    );
  }
}
