import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StorageController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // Método para seleccionar y subir imagen
  Future<String?> uploadImage(String folderName) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
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
    return null;
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
