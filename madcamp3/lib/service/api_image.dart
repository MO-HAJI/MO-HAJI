import 'package:http/http.dart' as http;

class APIImage {
  static var client = http.Client();

  Future<bool> uploadProfileImage(String? imageFile, String email) async {
    var url = Uri.http("127.0.0.1:8000", "/api/s3/image-upload");

    var request = http.MultipartRequest('POST', url);

    if (imageFile != null) {
      http.MultipartFile image =
          await http.MultipartFile.fromPath('profileimage', imageFile!);

      request.files.add(image);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      return true; // 이미지 업로드 성공
    } else {
      return false;
    }
  }
}
