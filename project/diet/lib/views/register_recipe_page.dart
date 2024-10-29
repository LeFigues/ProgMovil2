import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/recipe_controller.dart';
import '../controllers/storage_controller.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterRecipePage extends StatefulWidget {
  @override
  _RegisterRecipePageState createState() => _RegisterRecipePageState();
}

class _RegisterRecipePageState extends State<RegisterRecipePage> {
  final RecipeController recipeController = RecipeController();
  final StorageController storageController = StorageController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController ingredientNameController =
      TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  List<Ingredient> ingredients = [];
  File? _imageFile;
  String? imageUrl;

  void addIngredient() {
    final name = ingredientNameController.text;
    final quantity = double.tryParse(quantityController.text) ?? 0.0;
    final unit = unitController.text;

    if (name.isNotEmpty && quantity > 0 && unit.isNotEmpty) {
      setState(() {
        ingredients.add(Ingredient(name: name, quantity: quantity, unit: unit));
        ingredientNameController.clear();
        quantityController.clear();
        unitController.clear();
      });
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> registerRecipe() async {
    final name = nameController.text;
    final description = descriptionController.text;
    final caloriesPerGram = double.tryParse(caloriesController.text) ?? 0.0;
    final authorId = FirebaseAuth.instance.currentUser?.uid;

    if (authorId != null &&
        name.isNotEmpty &&
        description.isNotEmpty &&
        ingredients.isNotEmpty) {
      if (_imageFile != null) {
        imageUrl = await storageController.uploadImage(_imageFile!, 'recetas');
      }

      final recipe = Recipe(
        id: '',
        name: name,
        authorId: authorId,
        description: description,
        ingredients: ingredients,
        imageUrl: imageUrl ?? '',
        recipeType: 'Tipo de Receta',
        caloriesPerGram: caloriesPerGram,
      );

      await recipeController.addRecipe(recipe);
      for (var ingredient in ingredients) {
        await recipeController.addIngredientIfNotExists(ingredient);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Receta registrada con éxito')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Receta')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nombre de la receta'),
              ),
              SizedBox(height: 10),
              _imageFile != null
                  ? Image.file(_imageFile!, height: 150, fit: BoxFit.cover)
                  : TextButton(
                      onPressed: pickImage,
                      child: Text('Seleccionar Imagen'),
                    ),
              TextField(
                controller: descriptionController,
                decoration:
                    InputDecoration(labelText: 'Descripción de la receta'),
                maxLines: 3,
              ),
              TextField(
                controller: caloriesController,
                decoration: InputDecoration(labelText: 'Calorías por gramo'),
                keyboardType: TextInputType.number,
              ),
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
              SizedBox(height: 20),
              // Muestra la lista de ingredientes
              SizedBox(
                height: 150,
                child: ListView.builder(
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = ingredients[index];
                    return ListTile(
                      title: Text(
                          '${ingredient.quantity} ${ingredient.unit} de ${ingredient.name}'),
                    );
                  },
                ),
              ),
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
