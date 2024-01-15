import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:madcamp3/screens/bottom_navigation.dart';
import 'package:madcamp3/screens/edit_info.dart';
import 'package:madcamp3/screens/home.dart';
import 'package:madcamp3/screens/profile.dart';

import 'screens/login.dart';
import 'screens/signup.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: 'd3f1e3967b70cf433b69a618fadbde6d');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VisionApiExample(),
      routes: {
        '/tab': (context) => const TabPage(),
        '/mypage': (context) => const ProfilePage(),
        '/visionapi': (context) => VisionApiExample(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/edit': (context) => const EditInfoPage(),
      },
    );
  }
}

