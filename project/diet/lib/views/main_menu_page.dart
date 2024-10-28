import 'package:flutter/material.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú Principal')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/registerRecipe'),
              child: const Text('Registrar Receta'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/searchRecipes'),
              child: const Text('Buscar Recetas'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/savedRecipes'),
              child: const Text('Recetas Guardadas'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/userRecipes'), // Nuevo botón
              child: const Text('Mis Recetas'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/userProfile'),
              child: const Text('Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
