import 'package:flutter/material.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú Principal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Número de columnas
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuButton(
              context,
              label: 'Registrar Receta',
              route: '/registerRecipe',
            ),
            _buildMenuButton(
              context,
              label: 'Buscar Recetas',
              route: '/searchRecipes',
            ),
            _buildMenuButton(
              context,
              label: 'Recetas Guardadas',
              route: '/savedRecipes',
            ),
            _buildMenuButton(
              context,
              label: 'Mis Recetas',
              route: '/userRecipes',
            ),
            _buildMenuButton(
              context,
              label: 'Perfil',
              route: '/userProfile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required String label, required String route}) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, route),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
