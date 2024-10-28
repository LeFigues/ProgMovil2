import 'package:flutter/material.dart';
import '../controllers/recipe_controller.dart';
import '../controllers/user_controller.dart';
import '../controllers/storage_controller.dart'; // Importa el controlador de Storage
import '../models/recipe.dart';
import '../models/ingredient.dart';

class RegisterRecipePage extends StatefulWidget {
  @override
  _RegisterRecipePageState createState() => _RegisterRecipePageState();
}

class _RegisterRecipePageState extends State<RegisterRecipePage> {
  final RecipeController recipeController = RecipeController();
  final UserController userController = UserController();
  final StorageController storageController =
      StorageController(); // Instancia del controlador de Storage
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final List<Ingredient> ingredients = [];
  final TextEditingController ingredientNameController =
      TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitController = TextEditingController();

  String? selectedRecipeType;
  String? imageUrl;

  void addIngredient() {
    final name = ingredientNameController.text;
    final quantity = double.tryParse(quantityController.text) ?? 0.0;
    final unit = unitController.text;

    if (name.isNotEmpty && unit.isNotEmpty && quantity > 0) {
      final ingredient = Ingredient(name: name, quantity: quantity, unit: unit);
      setState(() {
        ingredients.add(ingredient);
      });
      ingredientNameController.clear();
      quantityController.clear();
      unitController.clear();
    }
  }

  Future<void> selectAndUploadImage() async {
    final url = await storageController.uploadImage('recipe_images');
    if (url != null) {
      setState(() {
        imageUrl = url;
      });
    }
  }

  void registerRecipe() async {
    final name = nameController.text;
    final description = descriptionController.text;
    final caloriesPerGram = double.tryParse(caloriesController.text) ?? 0.0;
    final authorId = userController.currentUser?.uid;

    if (authorId != null &&
        name.isNotEmpty &&
        description.isNotEmpty &&
        selectedRecipeType != null &&
        caloriesPerGram > 0 &&
        ingredients.isNotEmpty &&
        imageUrl != null) {
      final recipe = Recipe(
        id: '',
        name: name,
        authorId: authorId,
        description: description,
        ingredients: ingredients,
        imageUrl: imageUrl!,
        recipeType: selectedRecipeType!,
        caloriesPerGram: caloriesPerGram,
      );

      await recipeController.addRecipe(recipe);
      for (var ingredient in ingredients) {
        await recipeController.addIngredientIfNotExists(ingredient);
      }

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Receta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nombre de la receta'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    labelText: 'Descripción / Instrucciones de preparación'),
                maxLines: 3,
              ),
              DropdownButtonFormField<String>(
                value: selectedRecipeType,
                items: ['Vegano', 'Vegetariano', 'Sin gluten', 'Otro']
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => selectedRecipeType = value),
                decoration: InputDecoration(labelText: 'Tipo de receta'),
              ),
              TextField(
                controller: caloriesController,
                decoration: InputDecoration(labelText: 'Calorías por gramo'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: selectAndUploadImage,
                child: Text('Subir Imagen de la Receta'),
              ),
              if (imageUrl != null) Image.network(imageUrl!, height: 100),
              SizedBox(height: 20),
              TextField(
                controller: ingredientNameController,
                decoration:
                    InputDecoration(labelText: 'Nombre del ingrediente'),
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: unitController,
                decoration: InputDecoration(labelText: 'Unidad de medida'),
              ),
              ElevatedButton(
                onPressed: addIngredient,
                child: Text('Añadir Ingrediente'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: registerRecipe,
                child: Text('Registrar Receta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
