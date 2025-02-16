import 'dart:io';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = "https://ton-api.com/api";

  Future<String> uploadProfilePicture(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/user/upload-avatar'),
    );

    request.files.add(await http.MultipartFile.fromPath('avatar', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      return responseBody; // Retourne l'URL de la nouvelle image
    } else {
      throw Exception("Échec de l'upload de l'image");
    }
  }
}
