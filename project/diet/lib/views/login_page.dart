import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';

class LoginPage extends StatelessWidget {
  final UserController userController = UserController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;
    try {
      await userController.loginUser(email, password);
      Navigator.pushNamed(context, '/mainMenu'); // Redirige al menú principal
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error al iniciar sesión: $e")));
    }
  }

  void navigateToRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register'); // Navega a la página de registro
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => login(context),
              child: Text('Iniciar Sesión'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => navigateToRegister(context),
              child: Text('¿No tienes una cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}
