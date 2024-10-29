import 'package:diet/models/ingredient.dart';

class Recipe {
  final String id;
  final String name;
  final String authorId;
  final String? authorUsername; // Campo opcional para el username del autor
  final String description;
  final List<Ingredient> ingredients;
  final String imageUrl;
  final String recipeType;
  final double caloriesPerGram;

  Recipe({
    required this.id,
    required this.name,
    required this.authorId,
    this.authorUsername,
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
      'imageUrl': imageUrl,
      'recipeType': recipeType,
      'caloriesPerGram': caloriesPerGram,
    };
  }

  factory Recipe.fromMap(String id, Map<String, dynamic> data,
      {String? username}) {
    List<dynamic> ingredientMaps = data['ingredients'] ?? [];
    List<Ingredient> ingredients =
        ingredientMaps.map((map) => Ingredient.fromMap(map)).toList();

    return Recipe(
      id: id,
      name: data['name'],
      authorId: data['authorId'],
      authorUsername: username, // Asigna el username si se proporciona
      description: data['description'],
      ingredients: ingredients,
      imageUrl: data['imageUrl'],
      recipeType: data['recipeType'],
      caloriesPerGram: data['caloriesPerGram'].toDouble(),
    );
  }
}
