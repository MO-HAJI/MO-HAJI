import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:intl/intl.dart';
import 'package:madcamp3/models/food.dart';
import 'package:madcamp3/screens/widgets/foodInfo.dart';
import 'package:madcamp3/screens/widgets/naver.dart';

import '../service/api_google_vision.dart';
import '../service/api_gpt.dart';
import '../service/api_image.dart';
import '../models/user.dart';
import '../service/network.dart';

class other_user_food extends StatefulWidget {
  final String? userEmail;

  const other_user_food({Key? key, this.userEmail}) : super(key: key);

  @override
  State<other_user_food> createState() => _other_user_foodState();
}

class _other_user_foodState extends State<other_user_food> {
  int _current = 0;
  VisonApi visionApi = VisonApi();
  GptApi gptApi = GptApi();
  APIImage apiImage = APIImage();
  String? email;
  String? userName;

  final List<String> images = []; // url
  final List<String> menu = []; // keyword
  final List<String> recipe = []; // recipe
  final List<String> allergy = []; // allergy

  bool showRecipe = true;
  bool showMap = false;

  @override
  void initState() {
    super.initState();
    getDbData();
  }

  getDbData() async {
    Network network = Network();
    Map<String, String> check = {
      "email": widget.userEmail ?? "", // Use widget.userEmail here
    };
    var checked_data = await network.checkMemberByEmail(check);

    setState(() {
      email = checked_data['email'];
      userName = checked_data['name'];
    });

    List<FoodInfo> foodInfo = await apiImage.getFoodInfo(email!);

    setState(() {
      // Clear existing data in the lists
      images.clear();
      menu.clear();
      recipe.clear();
      allergy.clear();

      // Add new data from FoodInfoList to the lists
      for (var foodInfo in foodInfo) {
        images.add(foodInfo.url);
        menu.add(foodInfo.keyword);
        recipe.add(foodInfo.recipe);
        allergy.add(foodInfo.allergy);
      }
    });
  }

  List<Widget> generateImageTiles() {
    return images.map((element) {
      return ClipRRect(
        child: Image.network(
          apiImage.getImage(element),
          fit: BoxFit.cover,
          width: double.infinity,
          height: 100,
        ),
        borderRadius: BorderRadius.circular(15.0),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "$userName님의 게시물",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: [
            if (menu.length > 0)
              CarouselSlider(
                items: generateImageTiles(),
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  aspectRatio: 1.5,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                  enableInfiniteScroll: menu.length > 1,
                ),
              ),
            if (menu.length == 0)
              Center(
                child: Text(
                  "등록된 게시물이 없어요.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (menu.length > 0) // Check if menu.length is greater than 0
              Center(
                child: Text(
                  menu[_current].replaceAll("\"", ""),
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width / 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (menu.length > 0) // Check if menu.length is greater than 0
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    showRecipe ? '메뉴 정보' : '주변 맛집',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 150),
                  // Toggle button for Recipe
                  ToggleButtons(
                    children: [
                      Icon(Icons
                          .food_bank), // You can replace this with your own icon
                    ],
                    isSelected: [showRecipe],
                    onPressed: (int index) {
                      setState(() {
                        showRecipe = !showRecipe;
                        showMap =
                        !showRecipe; // Ensure only one option is selected at a time
                      });
                    },
                  ),
                  // Adjust spacing between buttons
                  // Toggle button for Map
                  ToggleButtons(
                    children: [
                      Icon(
                          Icons.map), // You can replace this with your own icon
                    ],
                    isSelected: [showMap],
                    onPressed: (int index) {
                      setState(() {
                        showMap = !showMap;
                        showRecipe =
                        !showMap; // Ensure only one option is selected at a time
                      });
                    },
                  ),
                ],
              ),
            if (_current < menu.length)
              Expanded(
                child: showRecipe
                    ? FoodInfoWidget(
                  recipe: recipe[_current],
                  allergy: allergy[_current],
                  // GPTmenu: menu[_current].replaceAll("\"", ""),
                )
                    :
                Container(
                  margin: EdgeInsets.only(top: 10), // Adjust the top margin as needed
                  child: NaverAPI(GPTmenu: menu[_current].replaceAll("\"", "")),
                ),
              ),
          ],
        ),
      ),
    );
  }
}