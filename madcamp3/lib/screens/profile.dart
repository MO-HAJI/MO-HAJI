import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:madcamp3/service/network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:madcamp3/service/api_image.dart';

enum genderType { male, female }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String userName = '';
  late String userBirth = '';
  late genderType userGender = genderType.female;
  late String userEmail = '';
  late String userPassword = '';
  late String userImage = '';

  late Color myColor;
  late Size mediaSize;

  final double coverHeight = 250;
  final double profileHeight = 150;

  Network network = Network();
  APIImage apiImage = APIImage();

  int followingCount = 0;
  int followerCount = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await getLoginInfo();
    await getDbData();
  }

  getDbData() async {
    Network network = Network();
    Map<String, String> check = {
      "email": userEmail,
    };
    var checked_data = await network.checkMemberByEmail(check);

    DateTime date = DateTime.parse(checked_data['birth']);
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    setState(() {
      userName = checked_data['name'];
      userBirth = formattedDate;
      userEmail = checked_data['email'];
      userPassword = checked_data['password'];
      userImage = checked_data['profile_image'];
    });

    var follower = await network.getFollowers(userEmail);
    var following = await network.getFollowings(userEmail);

    setState(() {
      followerCount = follower.length;
      followingCount = following.length;
    });
  }

  getLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';

    setState(() {
      userEmail = email.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    myColor = Colors.black;
    mediaSize = MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(
          color: myColor,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned(bottom: -5, child: _buildBottom()),
              Positioned(top: 30, child: _buildTop()),
            ],
          ),
        ));
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //로그아웃 버튼
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.remove('email');
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text('로그아웃',
                      style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                          fontSize: 16)),
                ),
              ],
            ),
          ),
          SizedBox(height: 80),
          CircleAvatar(
            radius: profileHeight / 1.5 + 3,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: profileHeight / 1.5,
              backgroundColor: Colors.grey.shade800,
              backgroundImage: userImage != null
                  ? NetworkImage(apiImage.getImage(userImage)!)
                  : AssetImage('assets/images/default_profile.png')
                      as ImageProvider,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      height: mediaSize.height - 350,
      child: Card(
        color: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                SizedBox(height: 60),
                _buildContent(),
                SizedBox(height: 5),
                _buildFollow(),
                SizedBox(height: 10),
                _buildEditButton(),
]
            ),

        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Text('${userName}',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        Text('${userEmail}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade700,
              height: 1.4,
            )),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEditButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white60,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/edit');
            },
            child: Text('정보 수정하기', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildFollow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildButton(text: 'Following', value: followingCount),
        SizedBox(width: 8),
        buildDivider(),
        SizedBox(width: 8),
        buildButton(text: 'Followers', value: followerCount),
      ],
    );
  }

  Widget buildButton({required String text, required int value}) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {
          text == 'Following'
              ? Navigator.pushNamed(context, '/following')
              : Navigator.pushNamed(context, '/follower');
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '$value',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      );

  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );
}
