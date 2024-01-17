import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:intl/intl.dart';
import 'package:madcamp3/models/food.dart';
import 'package:madcamp3/screens/widgets/foodInfo.dart';

import '../service/api_google_vision.dart';
import '../service/api_gpt.dart';
import '../service/api_image.dart';
import '../models/user.dart';
import '../service/network.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _current = 0;
  VisonApi visionApi = VisonApi();
  GptApi gptApi = GptApi();
  APIImage apiImage = APIImage();
  String? email;

  List<FoodInfo> foodInfo = [];

  final List<String> images = []; // url
  final List<String> menu = []; // keyword
  final List<String> recipe = []; // recipe
  final List<String> allergy = []; // allergy

  @override
  void initState() {
    super.initState();
    getDbData();
  }

  getDbData() async {
    Network network = Network();
    Map<String, String> check = {
      "email": User.current.email,
    };
    var checked_data = await network.checkMemberByEmail(check);

    setState(() {
      email = checked_data['email'];
    });

    foodInfo = await apiImage.getFoodInfo(email!);

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

  Future<void> _selectImage() async {
    final image_picker.ImagePicker picker = image_picker.ImagePicker();
    final image_picker.XFile? pickedFile =
        await picker.pickImage(source: image_picker.ImageSource.gallery);

    // loading circle
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });

    if (pickedFile != null) {
      final String? extractedScript =
          await visionApi.extractLabels(File(pickedFile.path));
      final String keyword = await gptApi.getKeyword(extractedScript!);

      XFile? _selectedImage = XFile(pickedFile.path);
      String? imagePath = _selectedImage?.path;

      await apiImage.uploadFoodImage(imagePath, email!, keyword);
      await getDbData();

      setState(() {
        _current = images.length - 1;
      });

      // remove loading circle
      Navigator.pop(context);
    }
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
      body: Container(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Stack(children: [
              CarouselSlider(
                items: [
                  ...generateImageTiles(),
                  // Add a custom item for the last page with an "Add Photo" button
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.grey[200], // You can customize the color
                    ),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await _selectImage();
                        },
                        child: Text('Add Photo'),
                      ),
                    ),
                  ),
                ],
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  aspectRatio: 1.5,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
              // image delete button
              if (_current < menu.length)
                Positioned(
                  top: 5,
                  right: 40,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.black54, // You can customize the color
                    ),
                    child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        iconSize: 15.0,
                        onPressed: () async {
                          // popup
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("음식 제거"),
                                  content: Text("이미지를 삭제하시겠습니까?"),
                                  actions: [
                                    TextButton(
                                      child: Text("취소"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text("삭제"),
                                      onPressed: () async {
                                        await apiImage.deleteFoodImage(
                                            foodInfo[_current].id.toString());

                                        await getDbData();

                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              });
                        }),
                  ),
                ),
            ]),
            if (_current <
                menu.length) // Only show the text when not on the "Add Photo" button
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
            if (_current < menu.length)
              Expanded(
                child: FoodInfoWidget(
                  recipe: recipe[_current],
                  allergy: allergy[_current],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
