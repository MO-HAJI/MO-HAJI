import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'util/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

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

  // Google Sign-In
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  bool _isGoogleSignInInProgress = false;

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
          inAsyncCall: isAPIcallProcess || _isGoogleSignInInProgress,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black54,
                    Colors.black54,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/AppLogo.png",
                    width: 180,
                    fit: BoxFit.contain,
                  ),
                )
              ],
            ),
          ),
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
            prefixIcon: Icon(Icons.account_box),
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
          // Google 로그인 버튼과 네이버 로그인 버튼을 가로로 묶음
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 가로 시작점 정렬
              children: [
                // Google 로그인 버튼
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: _googleSignInButton(),
                ),
                // 네이버 로그인 버튼
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: _naverSignInButton(),
                ),
                Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: _kakaoSignInButton(),
                ),
              ],
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
              padding: const EdgeInsets.only(top: 0),
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

  // Google 로그인 버튼 위젯
  Widget _googleSignInButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: ElevatedButton(
        onPressed: () async {
          await _handleGoogleSignIn();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/google_logo.png', // 구글 로고 이미지 경로
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Google 로그인 처리
  Future<void> _handleGoogleSignIn() async {
    try {
      setState(() {
        _isGoogleSignInInProgress = true;
      });
      GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        // Google 로그인 성공
        String googleEmail = googleSignInAccount.email;
        // 여기서 구글 로그인 성공 후 추가적인 로직을 수행할 수 있습니다.
        // 예를 들어, 해당 이메일로 회원 가입 또는 로그인 처리 등을 수행할 수 있습니다.
        print('Google Sign-In success. Email: $googleEmail');
      }
    } catch (error) {
      print('Google Sign-In error: $error');
    } finally {
      setState(() {
        _isGoogleSignInInProgress = false;
      });
    }
  }

  Widget _naverSignInButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: ElevatedButton(
        onPressed: () async {
          await _handleNaverSignIn();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/naver_logo.jpg', // 네이버 로고 이미지 경로
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 네이버 로그인 처리
  Future<void> _handleNaverSignIn() async {
    try {
      final NaverLoginResult res = await FlutterNaverLogin.logIn();
      print('Naver Sign-In result: $res');

      if (res.status == NaverLoginStatus.loggedIn) {
        // 네이버 로그인 성공
        String naverEmail = res.account.email;
        print('Naver Sign-In success. Email: $naverEmail');
      } else {
        // 로그인 실패 또는 사용자가 취소한 경우
        print('Naver Sign-In failed or user canceled.');
      }
    } catch (error) {
      print('Naver Sign-In error: $error');
    }
  }

  Widget _kakaoSignInButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: ElevatedButton(
        onPressed: () async {
          await _handleKakaoSignIn();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/kakao_logo.jpg', // 카카오 로고 이미지 경로
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// 카카오 로그인 처리
  Future<void> _handleKakaoSignIn() async {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print('카카오계정으로 로그인 성공 ${token.accessToken}');
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
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
