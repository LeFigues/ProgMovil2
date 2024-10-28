import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/user_controller.dart';
import 'views/login_page.dart';
import 'views/register_page.dart';
import 'views/user_page.dart';
import 'views/main_menu_page.dart';
import 'views/register_recipe_page.dart';
import 'views/search_recipes_page.dart';
import 'views/saved_recipes_page.dart';
import 'views/user_profile_page.dart';
import 'views/user_recipes_page.dart'; // Importa la nueva página

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBee20qfCWcuBnSc6hkeQ5Xha7dpiBLYNc",
      authDomain: "diet-e19e3.firebaseapp.com",
      projectId: "diet-e19e3",
      storageBucket: "diet-e19e3.appspot.com",
      messagingSenderId: "83413687870",
      appId: "1:83413687870:web:6a3c4d9fb21500952a3b6f",
      measurementId: "G-MJ8XBVZNCY",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserController userController = UserController();

  @override
  Widget build(BuildContext context) {
    final initialRoute =
        userController.currentUser != null ? '/mainMenu' : '/login';

    return MaterialApp(
      title: 'App de Recetas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/mainMenu': (context) => MainMenuPage(),
        '/registerRecipe': (context) => RegisterRecipePage(),
        '/searchRecipes': (context) => SearchRecipesPage(),
        '/savedRecipes': (context) {
          final userId = userController.currentUser?.uid ?? '';
          return SavedRecipesPage(userId: userId);
        },
        '/userProfile': (context) => UserProfilePage(),
        '/userRecipes': (context) {
          // Ruta para ver recetas del usuario
          final userId = userController.currentUser?.uid ?? '';
          return UserRecipesPage(userId: userId);
        },
        '/user': (context) {
          final userId = userController.currentUser?.uid;
          if (userId != null) {
            return UserPage(userId: userId);
          } else {
            return LoginPage();
          }
        },
      },
    );
  }
}
