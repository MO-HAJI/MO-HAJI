import '../../service/network.dart';

class Register {
  Network network = Network();

  Future<bool> register(String? name, String? email, String? password,
      String? birth, String? gender) async {
    int gender_num = 2;

    if (gender!.contains("male")) {
      gender_num = 0;
    } else if (gender!.contains("female")) {
      gender_num = 1;
    }

    Map<String, String> newMember = {
      "name": name.toString(),
      "birth": birth.toString(),
      "gender": gender_num.toString(),
      "email": email.toString(),
      "password": password.toString(),
    };

    print("name: " + name.toString());
    print("birth: " + birth.toString());
    print("gender" + gender_num.toString());
    print("email: " + email.toString());
    print("password: " + password.toString());

    network.addMember(newMember);

    if (name != null) {
      // 에러 뜬 경우
      return false;
    }
    return true;
  }
}
