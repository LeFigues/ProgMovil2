class Player {
  final String name;
  final int score;

  Player({required this.name, required this.score});

  // Método para convertir un Player a un formato de string
  String toStorageString() {
    return '$name: $score';
  }

  // Método para crear un Player a partir de un string
  static Player fromStorageString(String storageString) {
    List<String> parts = storageString.split(': ');
    return Player(name: parts[0], score: int.parse(parts[1]));
  }
}
