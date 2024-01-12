import '../../service/network.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Authentication {
  static List<Map<String, String>> validCredentials = [];
  late String validUserEmail = '';
  late String validUserPassword = '';
  static final storage = FlutterSecureStorage();

  Network network = Network();

  Future<bool> authenticate(String? email, String? password) async {
    // Simulate an asynchronous authentication process
    await Future.delayed(Duration(seconds: 1));

    Map<String, String> check = {
      "email": email.toString(),
      "password": password.toString(),
    };

    var checked_data = await network.login(check);

    var name = checked_data['message'];

    if (name == null) {
      // 에러 뜬 경우
      return false;
    }
    return true;
  }
}
