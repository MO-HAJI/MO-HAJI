import 'dart:convert';
import 'package:http/http.dart';
import 'package:madcamp3/models/food.dart';

import '../models/user.dart';
import 'package:http/http.dart' as http;

import 'api_gpt.dart';

class APIImage {
  final baseUrl = "3.39.88.217:8000";

  // final baseUrl = "127.0.0.1:8000";

  GptApi gptApi = GptApi();

  Future<bool> uploadProfileImage(String? imageFile, String email) async {
    var url = Uri.http(baseUrl, "/api/s3/image-upload");

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

  String getImage(String image) {
    var url = Uri.http("");
    String image_url =
        "https://madcamp3-image-bucket.s3.ap-northeast-2.amazonaws.com/" +
            image;
    return image_url;
  }

  Future<bool> uploadFoodImage(
      String? imageFile, String email, String keyword) async {
    var url = Uri.http(baseUrl, "/api/s3/image-upload");

    var request = http.MultipartRequest('POST', url);

    if (imageFile != null) {
      http.MultipartFile image =
          await http.MultipartFile.fromPath('foodimage', imageFile!);

      request.files.add(image);
    }

    request.fields['email'] = email;
    request.fields['keyword'] = keyword;
    request.fields['recipe'] = await gptApi.getRecipe(keyword);
    request.fields['allergy'] = await gptApi.getAllergy(keyword);

    var response = await request.send();

    if (response.statusCode == 200) {
      return true; // 이미지 업로드 성공
    } else {
      return false;
    }
  }

  Future<List<FoodInfo>> getFoodInfo(String email) async {
    var url = Uri.http(baseUrl, "/api/s3/foodimage/" + email);

    try {
      final response = await get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${User.current.token}",
        },
      );

      var userJson = response.body;
      var parsingData = jsonDecode(userJson);
      var dataList = parsingData['data'];

      List<FoodInfo> foodInfoList = [];

      for (var data in dataList) {
        foodInfoList.add(FoodInfo.fromJson(data));
      }

      return foodInfoList;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
