import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart';

import '../models/user.dart';

class Network {
  final baseUrl = "http://3.39.88.217:8000/api/users";

  // 전체 멤버 탐색
  Future<dynamic> allMember() async {
    var url = Uri.parse(baseUrl + '/');
    final response = await get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${User.current.token}"
      },
    );
    var userJson = response.body;
    var parsingData = jsonDecode(userJson);
    return parsingData;
  }

  // 회원가입 또는 멤버 추가
  Future<dynamic> addMember(Map<String, String> newMember) async {
    var url = Uri.parse(baseUrl + '/');

    try {
      final response = await post(
        url,
        body: jsonEncode(newMember),
        headers: {
          "Content-Type": "application/json",
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      print("실패!!!!!!!!");

      return {};
    }
  }

  Future<Map> getMember(String id) async {
    var url = Uri.parse(baseUrl + '/' + id);
    try {
      final response = await get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${User.current.token}"
        },
      );
      var userJson = response.body;
      var parsingData = jsonDecode(userJson);
      return parsingData;
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map> checkMemberByEmail(Map<String, String> checkMember) async {
    var url = Uri.parse(baseUrl + '/' + checkMember['email'].toString());
    try {
      final response = await get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${User.current.token}"
        },
      );
      var userJson = response.body;
      var parsingData = jsonDecode(userJson);
      return parsingData['data'];
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map> updateMember(Map<String, String> updateMember) async {
    var url = Uri.parse(baseUrl + '/');
    try {
      final response = await put(
        url,
        body: jsonEncode(updateMember),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${User.current.token}"
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<dynamic> login(Map<String, String> checkMember) async {
    var url = Uri.parse(baseUrl + '/login');
    try {
      final response = await post(
        url,
        body: jsonEncode(checkMember),
        headers: {"Content-Type": "application/json"},
      );
      var userJson = response.body;
      var jsonResponse = jsonDecode(userJson);
      User.initialize(
          '1', checkMember['email']!, 'name', jsonResponse["token"]);
      return jsonResponse;
    } catch (e) {
      print(["error", e]);
      return {};
    }
  }

  Future<dynamic> patchUserBackGroundImage(dynamic input) async {
    print("프로필 사진을 서버에 업로드 합니다.");
    var dio = new Dio();
    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;
      dio.options.headers = {"Authorization": "Bearer ${User.current.token}"};

      var response = await dio.patch(
        baseUrl + '/users/backgroundimage',
        data: input,
      );
      print('성공적으로 업로드했습니다');
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future<Map> getNews() async {
    var url = Uri.parse(baseUrl + '/news');
    try {
      final response = await get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      var userJson = response.body;
      var parsingData = jsonDecode(userJson);
      return parsingData;
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map> getAllYoutube() async {
    var url = Uri.parse(baseUrl + '/youtube');
    try {
      final response = await get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      var userJson = response.body;
      var parsingData = jsonDecode(userJson);
      return parsingData;
    } catch (e) {
      print(e);
      return {};
    }
  }

  // youtube url 보내기
  Future<Map> sendUrl(String youtubeUrl) async {
    var url = Uri.parse(baseUrl + '/youtube');

    try {
      final response = await post(
        url,
        body: jsonEncode({"url": youtubeUrl}),
        headers: {"Content-Type": "application/json"},
      );
      var userJson = response.body;
      var parsingData = jsonDecode(userJson);
      return parsingData;
    } catch (e) {
      print(e);
      return {};
    }
  }

  // keyword string 3개 보내기
  Future<Map> sendKeyword(String words) async {
    var url = Uri.parse(baseUrl + '/news/search');

    try {
      final response = await post(
        url,
        body: jsonEncode({"keyword": words}),
        headers: {"Content-Type": "application/json"},
      );
      var userJson = response.body;
      var parsingData = jsonDecode(userJson);
      return parsingData;
    } catch (e) {
      print(e);
      return {};
    }
  }
}
