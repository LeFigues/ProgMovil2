import 'package:flutter/material.dart';

class MainMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menú Principal')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/registerRecipe'),
              child: Text('Registrar Receta'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/searchRecipes'),
              child: Text('Buscar Recetas'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/savedRecipes'),
              child: Text('Recetas Guardadas'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/userRecipes'), // Nuevo botón
              child: Text('Mis Recetas'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/userProfile'),
              child: Text('Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
