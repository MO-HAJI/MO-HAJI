import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:madcamp3/screens/bottom_navigation.dart';
import 'package:madcamp3/screens/edit_info.dart';
import 'package:madcamp3/screens/profile.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:madcamp3/screens/widgets/follower.dart';
import 'package:madcamp3/screens/widgets/following.dart';

import 'screens/login.dart';
import 'screens/signup.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: 'd3f1e3967b70cf433b69a618fadbde6d');
  await NaverMapSdk.instance.initialize(clientId: 'hxz7cc3je7');
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
      home: LoginPage(),
      routes: {
        '/tab': (context) => const TabPage(),
        '/mypage': (context) => const ProfilePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/edit': (context) => const EditInfoPage(),
        '/following': (context) => const FollowingPage(),
        '/follower': (context) => const FollowerPage(),
      },
    );
  }
}
