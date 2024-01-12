import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../service/network.dart';

enum genderType { male, female }

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;

  // DateTime? birth = DateTime(0, 0, 0);
  String? birth = "1901-01-01";
  genderType? gender;
  String? gender_;
  String? genderOnly = "성별";
  String? email;
  String? password;

  Network network = Network();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: ProgressHUD(
        child: Form(
          key: globalFormKey,
          child: _registerUI(context),
        ),
        inAsyncCall: isAPIcallProcess,
        opacity: 0.3,
        key: UniqueKey(),
      ),
    ));
  }

  Widget _registerUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height / 4.5,
            //   decoration: const BoxDecoration(
            //       gradient: LinearGradient(
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //         colors: [
            //           Colors.black54,
            //           Colors.black54,
            //         ],
            //       ),
            //       borderRadius: BorderRadius.only(
            //         bottomLeft: Radius.circular(100),
            //         bottomRight: Radius.circular(100),
            //       )),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Align(
            //         alignment: Alignment.center,
            //         child: Image.asset(
            //           "assets/images/AppLogo.png",
            //           width: 180,
            //           fit: BoxFit.contain,
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                bottom: 30,
                top: 50,
              ),
              child: Text(
                "회원가입",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
            FormHelper.inputFieldWidget(
              context,
              "username",
              "이름(닉네임)",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return '이름(닉네임)을 입력해주세요.';
                }

                return null;
              },
              (onSavedVal) {
                username = onSavedVal;
              },
              borderFocusColor: Colors.black,
              prefixIconColor: Colors.black,
              borderColor: Colors.black,
              textColor: Colors.black,
              hintColor: Colors.black.withOpacity(0.7),
              borderRadius: 10,
              showPrefixIcon: true,
              prefixIcon: Icon(Icons.person),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FormHelper.inputFieldWidget(
                context,
                "email",
                "이메일",
                (onValidateVal) {
                  if (onValidateVal.isEmpty) {
                    return '이메일을 입력해주세요.';
                  }

                  if (validateEmail(onValidateVal) != null) {
                    return validateEmail(onValidateVal);
                  }

                  return null;
                },
                (onSavedVal) {
                  email = onSavedVal;
                },
                borderFocusColor: Colors.black,
                prefixIconColor: Colors.black,
                borderColor: Colors.black,
                textColor: Colors.black,
                hintColor: Colors.black.withOpacity(0.7),
                borderRadius: 10,
                showPrefixIcon: true,
                prefixIcon: Icon(Icons.account_box),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FormHelper.inputFieldWidget(
                context,
                "password",
                "비밀번호",
                (onValidateVal) {
                  if (onValidateVal.isEmpty) {
                    return '비밀번호를 입력해주세요.';
                  }

                  if (validatePassword(onValidateVal) != null) {
                    return validatePassword(onValidateVal);
                  }

                  return null;
                },
                (onSavedVal) {
                  password = onSavedVal;
                },
                borderFocusColor: Colors.black,
                prefixIconColor: Colors.black,
                borderColor: Colors.black,
                textColor: Colors.black,
                hintColor: Colors.black.withOpacity(0.7),
                borderRadius: 10,
                showPrefixIcon: true,
                prefixIcon: Icon(Icons.password),
                obscureText: hidePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  color: Colors.black.withOpacity(0.7),
                  icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Row의 크기를 최소화
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (birth != null)
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            (birth == "1901-01-01")
                                ? "생년월일을 입력해주세요."
                                : birth.toString(),
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    IconButton(
                      alignment: Alignment.centerRight,
                      onPressed: () async {
                        final String? selectedDate = await _birth(context);
                        if (selectedDate != null) {
                          setState(() {
                            birth = selectedDate;
                            print("Selected Date: $birth");
                          });
                        }
                      },
                      icon: Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Row의 크기를 최소화
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          "$genderOnly",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: DropdownButton(
                        value: gender,
                        items: genderType.values.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value == genderType.male ? '남자' : '여자',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (selectedGender) {
                          // Handle value change
                          setState(() {
                            gender = selectedGender as genderType?;
                            if (gender.toString().contains("female")) {
                              genderOnly = "여자";
                            } else if (gender.toString().contains("male")) {
                              genderOnly = "남자";
                            } else {
                              genderOnly = "성별";
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: FormHelper.submitButton(
                "회원가입",
                () async {
                  if (validateAndSave()) {
                    Map<String, String> newmember = {};
                    newmember['name'] = username!;
                    newmember['email'] = email!;
                    newmember['password'] = password!;
                    newmember['birth'] = birth!;
                    if (gender.toString().contains("female")) {
                      gender_ = "1";
                    } else {
                      gender_ = "0";
                    }
                    newmember['gender'] = gender_!;
                    var success = await network.addMember(newmember);
                    if (success['success'] == 1) {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        "app_name",
                        "회원가입 성공 !!",
                        "OK",
                        () {
                          Navigator.pushNamed(context, '/login');
                        },
                      );
                    } else {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        "app_name",
                        "회원가입 실패 !!",
                        "OK",
                        () {
                          Navigator.pushNamed(context, '/register');
                        },
                      );
                    }
                  }
                },
                btnColor: Colors.white,
                borderColor: Colors.black,
                txtColor: Colors.black,
                borderRadius: 10,
              ),
            ),
          ]),
    );
  }

  Future<String?> _birth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // Format the selected date as a string
      String formattedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

      return formattedDate;
    }

    return null;
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // 이메일 형식 확인 함수
  String? validateEmail(String value) {
    String pattern =
        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$'; // 기본적인 이메일 형식 정규식
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return '올바른 이메일 형식이 아닙니다.';
    }
    return null;
  }

// 비밀번호 형식 확인 함수
  String? validatePassword(String value) {
    // 비밀번호는 최소 8자 이상, 영문, 숫자, 특수문자를 포함해야 함
    String pattern =
        r'^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}|:;<>,.?/~]).{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return '비밀번호는 8자 이상, 영문, 숫자, 특수문자를 포함해야 합니다.';
    }
    return null;
  }
}
