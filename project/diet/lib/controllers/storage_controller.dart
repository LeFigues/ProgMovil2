import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageController {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Método para subir imagen, ahora acepta un `File` directamente
  Future<String?> uploadImage(File imageFile, String folderName) async {
    String fileName = DateTime.now().toString();

    try {
      final storageRef = _storage.ref().child('$folderName/$fileName');
      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Error al subir la imagen: $e");
      return null;
    }
  }

  // Método para eliminar imagen por URL
  Future<void> deleteImage(String imageUrl) async {
    try {
      await _storage.refFromURL(imageUrl).delete();
    } catch (e) {
      print("Error al eliminar la imagen: $e");
    }
  }
}
