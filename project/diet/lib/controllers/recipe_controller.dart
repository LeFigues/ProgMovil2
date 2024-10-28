import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';

class RecipeController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addRecipe(Recipe recipe) async {
    await firestore.collection('recipes').add(recipe.toMap());
  }

  Future<List<Recipe>> getRecipes() async {
    final snapshot = await firestore.collection('recipes').get();
    return snapshot.docs
        .map((doc) => Recipe.fromMap(doc.id, doc.data()))
        .toList();
  }

  // Método para obtener recetas creadas por un usuario específico
  Future<List<Recipe>> getUserRecipes(String userId) async {
    final snapshot = await firestore
        .collection('recipes')
        .where('authorId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => Recipe.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await firestore.collection('recipes').doc(recipe.id).update(recipe.toMap());
  }

  Future<void> deleteRecipe(String recipeId) async {
    await firestore.collection('recipes').doc(recipeId).delete();
  }

  Future<void> addIngredientIfNotExists(Ingredient ingredient) async {
    final snapshot = await firestore
        .collection('ingredients')
        .where('name', isEqualTo: ingredient.name)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      await firestore.collection('ingredients').add(ingredient.toMap());
    }
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    final snapshot = await firestore
        .collection('recipes')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    return snapshot.docs
        .map((doc) => Recipe.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<List<Recipe>> getSavedRecipes(String userId) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('saved_recipes')
        .get();
    return snapshot.docs
        .map((doc) => Recipe.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> saveRecipeForUser(String userId, Recipe recipe) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('saved_recipes')
        .doc(recipe.id)
        .set(recipe.toMap());
  }
}
