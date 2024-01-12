import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import 'util/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAPIcallProcess = false;
  bool isAuth = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? email;
  String? password;
  Authentication authentication = Authentication();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: ProgressHUD(
        child: Form(
          key: globalFormKey,
          child: _loginUI(context),
        ),
        inAsyncCall: isAPIcallProcess,
        opacity: 0.3,
        key: UniqueKey(),
      ),
    ));
  }

  Widget _loginUI(BuildContext context) {
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
              "로그인",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),
          FormHelper.inputFieldWidget(
            context,
            "email",
            "이메일",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return '이메일을 입력해주세요.';
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
            prefixIcon: Icon(Icons.person),
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
              prefixIcon: Icon(Icons.person),
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
            height: 30,
          ),
          Center(
            child: FormHelper.submitButton(
              "로그인",
              () async {
                if (validateAndSave()) {
                  isAuth = await authentication.authenticate(email, password);
                  if (isAuth) {
                    saveUserInfo(email.toString());
                    Navigator.pushNamed(context, '/tab');
                  } else {
                    print("Login failed");
                    FormHelper.showSimpleAlertDialog(
                      context,
                      "app_name",
                      "Invalid Username/Password !!",
                      "OK",
                      () {
                        Navigator.of(context).pop();
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
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "OR",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 25, top: 10),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: "계정이 없으신가요? "),
                    TextSpan(
                      text: '회원가입',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, '/register');
                        },
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> saveUserInfo(String email) async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('username', username);
    await prefs.setString('email', email);
  }
}
