class User {
  final String id;
  final String username;
  final String email;

  User({required this.id, required this.username, required this.email});

  // Método para convertir un usuario a un mapa (para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
    };
  }

  // Método para crear un usuario desde un mapa (de Firestore)
  factory User.fromMap(String id, Map<String, dynamic> data) {
    return User(
      id: id,
      username: data['username'],
      email: data['email'],
    );
  }
}
