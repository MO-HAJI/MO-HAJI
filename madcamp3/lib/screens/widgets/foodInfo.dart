import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../service/api_image.dart';
import 'naver.dart';

class FoodInfoWidget extends StatelessWidget {
  final String recipe;
  final String allergy;
  // String GPTmenu;
  APIImage apiImage = APIImage();

  // FoodInfoWidget(
  //     {required this.recipe, required this.allergy, required this.GPTmenu});

  FoodInfoWidget({required this.recipe, required this.allergy});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              recipe,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          // Allergy
          Text(
            allergy,
            style: TextStyle(
              color: Colors.red, // You can customize the color
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
