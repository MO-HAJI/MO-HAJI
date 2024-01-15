import 'package:http/http.dart' as http;

class APIImage {
  static var client = http.Client();

  Future<bool> uploadProfileImage(String? imageFile, String email) async {
    var url = Uri.http("127.0.0.1:8000", "/api/s3/image-upload");

    // var s3Uri = Uri.parse("https://s3.ap-northeast-2.amazonaws.com");

    var request = http.MultipartRequest('POST', url);

    if (imageFile != null) {
      http.MultipartFile image =
          await http.MultipartFile.fromPath('profileimage', imageFile!);

      request.files.add(image);
    }

    request.fields['email'] = email;

    var response = await request.send();

    if (response.statusCode == 200) {
      return true; // 이미지 업로드 성공
    } else {
      return false;
    }
  }

  Future<String> getProfileImage(String email) async {
    var url = Uri.http("");
    String image_url =
        "https://madcamp3-image-bucket.s3.ap-northeast-2.amazonaws.com/";

    return image_url;
  }
}
