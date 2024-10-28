import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../models/user.dart';

class UserController {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getter para el usuario actual
  fb_auth.User? get currentUser => _auth.currentUser;

  // Registro de usuario con Firebase Authentication y Firestore
  Future<void> registerUser(
      String username, String email, String password) async {
    fb_auth.UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Crear usuario en Firestore
    User user =
        User(id: userCredential.user!.uid, username: username, email: email);
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  // Inicio de sesión de usuario
  Future<fb_auth.User?> loginUser(String email, String password) async {
    fb_auth.UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // Obtener datos de usuario
  Future<User> getUser(String userId) async {
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(userId).get();
    return User.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  // Actualizar perfil de usuario
  Future<void> updateUser(User user) async {
    await _firestore.collection('users').doc(user.id).update(user.toMap());
  }

  // Eliminar usuario
  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
    await _auth.currentUser?.delete();
  }
}
