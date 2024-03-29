import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart';

import '../models/user.dart';

class Network {
  final baseUrl = "http://3.39.88.217:8000/api/users";

  // final baseUrl = "http://127.0.0.1:8000/api/users";

  // 전체 멤버 탐색
  Future<List<Map<String, dynamic>>> allMember() async {
    var url = Uri.parse(baseUrl + '/');
    try {
      final response = await get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${User.current.token}"
        },
      );

      if (response.statusCode == 200) {
        var userJson = response.body;
        var parsingData = jsonDecode(userJson);
        // Make sure 'data' is a List<Map<String, dynamic>>
        if (parsingData['data'] is List) {
          return List<Map<String, dynamic>>.from(parsingData['data']);
        } else {
          // Handle the case when 'data' is not a List
          print('Unexpected response format: ${parsingData['data']}');
          return [];
        }
      } else {
        print('Failed to fetch users. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
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

  Future<dynamic> followUser(String userEmail, String followEmail) async {
    var url = Uri.parse(baseUrl + '/follow');
    try {
      final response = await post(
        url,
        body: jsonEncode({
          'email': userEmail,
          'follow_email': followEmail,
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${User.current.token}", // Corrected the syntax here
        },
      );

      if (response.statusCode == 200) {
        var userJson = response.body;
        return jsonDecode(userJson);
      } else {
        print('Failed to follow user. Status code: ${response.statusCode}');
        return {'error': 'Failed to follow user'};
      }
    } catch (e) {
      print(e);
      return {'error': 'Failed to follow user'};
    }
  }

  Future<dynamic> unfollowUser(String userEmail, String followEmail) async {
    var url = Uri.parse(baseUrl + '/unfollow');
    try {
      final response = await post(
        url,
        body: jsonEncode({
          'email': userEmail,
          'follow_email': followEmail,
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${User.current.token}", // Corrected the syntax here
        },
      );

      if (response.statusCode == 200) {
        var userJson = response.body;
        return jsonDecode(userJson);
      } else {
        print('Failed to unfollow user. Status code: ${response.statusCode}');
        return {'error': 'Failed to unfollow user'};
      }
    } catch (e) {
      print(e);
      return {'error': 'Failed to unfollow user'};
    }
  }

  Future<List<Map<String, dynamic>>> getFollowers(String userEmail) async {
    var url = Uri.parse(baseUrl + '/followers/' + userEmail);
    try {
      final response = await get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${User.current.token}"
        },
      );

      if (response.statusCode == 200) {
        var userJson = response.body;
        var parsingData = jsonDecode(userJson);
        // Make sure 'data' is a List<Map<String, dynamic>>
        if (parsingData['data'] is List) {
          return List<Map<String, dynamic>>.from(parsingData['data']);
        } else {
          // Handle the case when 'data' is not a List
          print('Unexpected response format: ${parsingData['data']}');
          return [];
        }
      } else {
        print('Failed to fetch users. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<dynamic> getFollowings(String userEmail) async {
    var url = Uri.parse(baseUrl + '/followings/' + userEmail);
    try {
      final response = await get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${User.current.token}"
        },
      );

      if (response.statusCode == 200) {
        var userJson = response.body;
        var parsingData = jsonDecode(userJson);
        // Make sure 'data' is a List<Map<String, dynamic>>
        if (parsingData['data'] is List) {
          return List<Map<String, dynamic>>.from(parsingData['data']);
        } else {
          // Handle the case when 'data' is not a List
          print('Unexpected response format: ${parsingData['data']}');
          return [];
        }
      } else {
        print('Failed to fetch users. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<int> checkIfFollowing(String userEmail, String targetEmail) async {
    var url = Uri.parse(baseUrl + '/checkfollowing');
    try {
      final response = await post(
        url,
        body: jsonEncode({
          'email': userEmail,
          'target_email': targetEmail,
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${User.current.token}", // Corrected the syntax here
        },
      );

      if (response.statusCode == 200) {
        var userJson = response.body;
        return jsonDecode(userJson)['result'];
      } else {
        print(
            'Failed to check if following. Status code: ${response.statusCode}');
        return -1;
      }
    } catch (e) {
      print(e);
      return -1;
    }
  }
}
