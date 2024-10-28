import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';
import '../models/user.dart';

class UserPage extends StatefulWidget {
  final String userId;

  UserPage({required this.userId});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UserController userController = UserController();
  late User user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    user = await userController.getUser(widget.userId);
    setState(() {});
  }

  void deleteUser() async {
    await userController.deleteUser(user.id);
    Navigator.pop(context); // Regresa a la pantalla anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil de Usuario')),
      body: user == null
          ? CircularProgressIndicator()
          : Column(
              children: [
                Text('Nombre: ${user.username}'),
                Text('Correo: ${user.email}'),
                ElevatedButton(
                    onPressed: deleteUser, child: Text('Eliminar cuenta')),
              ],
            ),
    );
  }
}
